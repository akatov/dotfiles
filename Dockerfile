# Tool versions, gathered here so bumps happen in one place. ARGs declared
# before FROM are only visible in FROM lines, so each stage re-declares the
# ones it needs with a bare `ARG NAME` (which inherits the value from here).
# Re-declare each one right before the RUN that uses it: changing an ARG
# invalidates the cache from the first RUN after its declaration, so a
# chezmoi bump still won't re-download dprint.
ARG DPRINT_VERSION=0.55.2
# Keep in sync with .chezmoiversion.
ARG CHEZMOI_VERSION=2.72.0
# Match the Emacs on the host Mac. The checksum is of the release tarball,
# verified once against its GPG signature (signed by Sean Whitton).
ARG EMACS_VERSION=31.1
ARG EMACS_SHA256=1da5790d9580c81932b5bf700633114468da7b3412d69faa767daebf974f4586
# trixie ships tree-sitter 0.22.6, which only loads grammar ABI 13-14; current
# grammars (javascript, python, ...) are generated for ABI 15 (tree-sitter 0.25+).
ARG TREE_SITTER_VERSION=0.27.1

# Base image pinned by multi-arch index digest (tag trixie-slim, Debian 13.7, as
# of 2026-10-29). The index digest keeps the image multi-arch; a per-platform
# digest would break amd64 CI or arm64 laptops depending on which one was picked.
# Both stages use it so the built Emacs links against exactly the libraries it
# runs with.
ARG BASE_IMAGE=debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4

# ---------------------------------------------------------------------------
# Build stage: Emacs from source (Debian has no Emacs 31 package). Only the
# installed files are copied out, so compilers and -dev packages stay here.
FROM ${BASE_IMAGE} AS emacs-build
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
      ca-certificates curl xz-utils build-essential pkg-config \
      libgtk-3-dev libgccjit-14-dev libgnutls28-dev libncurses-dev libxml2-dev \
      libharfbuzz-dev libjpeg-dev libpng-dev libgif-dev libtiff-dev librsvg2-dev \
      libwebp-dev libsqlite3-dev libxpm-dev libgmp-dev libacl1-dev libdbus-1-dev \
      liblcms2-dev \
    && rm -rf /var/lib/apt/lists/*

# Installed twice: into /usr/local so Emacs' configure finds it, and into
# /staging so it gets copied into the final image alongside Emacs.
ARG TREE_SITTER_VERSION
RUN curl -fsSL "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v${TREE_SITTER_VERSION}.tar.gz" \
      | tar -xz -C /tmp \
    && make -C "/tmp/tree-sitter-${TREE_SITTER_VERSION}" -j"$(nproc)" \
    && make -C "/tmp/tree-sitter-${TREE_SITTER_VERSION}" install PREFIX=/usr/local \
    && make -C "/tmp/tree-sitter-${TREE_SITTER_VERSION}" install PREFIX=/usr/local DESTDIR=/staging \
    && ldconfig \
    && rm -rf "/tmp/tree-sitter-${TREE_SITTER_VERSION}"

# --with-native-compilation=aot compiles all bundled Lisp at build time, so the
# container doesn't spend its first minutes native-compiling Emacs itself.
ARG EMACS_VERSION
ARG EMACS_SHA256
RUN curl -fsSL "https://ftp.gnu.org/gnu/emacs/emacs-${EMACS_VERSION}.tar.xz" -o /tmp/emacs.tar.xz \
    && echo "${EMACS_SHA256}  /tmp/emacs.tar.xz" | sha256sum -c - \
    && tar -xJf /tmp/emacs.tar.xz -C /tmp \
    && cd "/tmp/emacs-${EMACS_VERSION}" \
    && ./configure --prefix=/usr/local \
      --with-x-toolkit=gtk3 --with-cairo --with-harfbuzz \
      --with-native-compilation=aot --with-tree-sitter \
      --with-gnutls --with-xml2 --with-rsvg --with-webp --with-sqlite3 \
      --without-mailutils \
    && make -j"$(nproc)" \
    && make install DESTDIR=/staging \
    && rm -rf /tmp/emacs.tar.xz "/tmp/emacs-${EMACS_VERSION}"

# ---------------------------------------------------------------------------
FROM ${BASE_IMAGE}

# pipefail: a `curl | sh` below would otherwise pass on a failed download (the
# pipeline's status is sh's).
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Basics the devcontainer base image used to provide. procps is needed by the
# VS Code server; openssh-client and gnupg let VS Code's forwarded ssh/gpg
# agents work; unzip is what dprint's installer requires; zsh matches the shell
# the dotfiles' CI (boot.yml) exercises.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
      ca-certificates curl git gnupg less locales openssh-client procps sudo \
      unzip xz-utils zsh \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8

# Non-root user with passwordless sudo, named and numbered like the one in the
# other devcontainers (uid/gid 1000 matches the usual host user, so files in
# the bind-mounted workspace keep sane ownership).
RUN groupadd --gid 1000 agent \
    && useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash agent \
    && echo "agent ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/agent \
    && chmod 0440 /etc/sudoers.d/agent

# Emacs' runtime libraries, plus what's needed to run it as a GUI headlessly:
# Xvfb (virtual X server), xwd/imagemagick for screenshots, and Fira Code for
# fira-code-mode. libgccjit-14-dev (not just libgccjit0) is needed at runtime:
# native-compiling packages links against libgcc and the crt files that only
# the -dev package ships.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
      libgtk-3-0t64 libcairo2 libharfbuzz0b libgccjit-14-dev libgnutls30t64 \
      libncurses6 libxml2 libjpeg62-turbo libpng16-16t64 libgif7 libtiff6 \
      librsvg2-2 libwebp7 libwebpdemux2 libsqlite3-0 libxpm4 libgmp10 libacl1 \
      libdbus-1-3 liblcms2-2 libsm6 libice6 \
      xvfb xauth x11-apps imagemagick fonts-firacode \
    && rm -rf /var/lib/apt/lists/*

# Fails the build if a runtime library is missing, or if native compilation or
# tree-sitter (with ABI 15 support) don't actually work.
COPY --from=emacs-build /staging/usr/local/ /usr/local/
RUN ldconfig \
    && ! ldd /usr/local/bin/emacs | grep 'not found' \
    && emacs --version \
    && emacs -Q --batch --eval '(progn \
         (unless (native-comp-available-p) (error "no native-comp")) \
         (unless (>= (treesit-library-abi-version) 15) (error "tree-sitter ABI < 15")) \
         (native-compile (lambda (x) x)))'

# What the dotfiles reference: packages.toml installs tmux, tig, bat, zile and
# ag on the Mac, and the shell config has an EDITOR fallback to zile and a tmux
# TERM tweak, so the container gets the same. Plus the usual shell conveniences
# and jq (yq isn't in Debian; see below). Debian renames bat and fd to avoid
# name clashes, so the usual names are symlinked.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
      bash-completion bat fd-find fzf jq nano psmisc ripgrep rsync \
      silversearcher-ag tig tmux zile \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/batcat /usr/local/bin/bat \
    && ln -s /usr/bin/fdfind /usr/local/bin/fd

# dprint: the installer takes the version as a positional argument; with none it
# resolves to /latest/ and the image silently drifts.
ARG DPRINT_VERSION
RUN curl -fsSL https://dprint.dev/install.sh | DPRINT_INSTALL="/usr/local" sh -s -- "${DPRINT_VERSION}" \
    && dprint --version

# chezmoi: installed here rather than via the devcontainer feature. The feature
# defaults to version "latest" and its install script may run apt-get update,
# so its layer both drifts and costs ~30s on every rebuild. Placed last so a
# bump doesn't re-download dprint. Each command self-verifies by running the
# binary -- `which` would only prove a file landed, not that it matches the
# platform.
ARG CHEZMOI_VERSION
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_${ARCH}.tar.gz" \
      -o /tmp/chezmoi.tar.gz \
    && tar -xzf /tmp/chezmoi.tar.gz -C /tmp chezmoi \
    && install /tmp/chezmoi /usr/local/bin/chezmoi \
    && rm /tmp/chezmoi /tmp/chezmoi.tar.gz \
    && chezmoi --version

USER agent

# Mount points for the named volumes in devcontainer.json. Created here, as the
# agent user, because Docker seeds an empty volume from the image's directory
# (ownership included); a missing directory would come up root-owned.
RUN mkdir -p /home/agent/.claude /home/agent/.vscode-server
