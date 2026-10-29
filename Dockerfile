# Tool versions, gathered here so bumps happen in one place. ARGs declared
# before FROM are only visible in FROM lines, so each stage re-declares the
# ones it needs with a bare `ARG NAME` (which inherits the value from here).
# Re-declare each one right before the RUN that uses it: changing an ARG
# invalidates the cache from the first RUN after its declaration, so a
# chezmoi bump still won't re-download dprint.
ARG DPRINT_VERSION=0.55.2
# Keep in sync with .chezmoiversion.
ARG CHEZMOI_VERSION=2.72.0

# Base image pinned by multi-arch index digest (tag trixie-slim, Debian 13.7, as
# of 2026-10-29). The index digest keeps the image multi-arch; a per-platform
# digest would break amd64 CI or arm64 laptops depending on which one was picked.
ARG BASE_IMAGE=debian:trixie-slim@sha256:f6b08b09a05725f9431502d3b5714f5c4576e82c1a84fa1debe0c24a7e0c3ec4

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
