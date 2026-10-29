# Tool versions, gathered here so bumps happen in one place. ARGs declared
# before FROM are only visible in FROM lines, so each stage re-declares the
# ones it needs with a bare `ARG NAME` (which inherits the value from here).
# Re-declare each one right before the RUN that uses it: changing an ARG
# invalidates the cache from the first RUN after its declaration, so a
# chezmoi bump still won't re-download dprint.
ARG DPRINT_VERSION=0.55.2
# Keep in sync with .chezmoiversion.
ARG CHEZMOI_VERSION=2.72.0

# Base image pinned by multi-arch index digest (tag 1-22-bookworm as of 2026-08-06).
# The index digest keeps the image multi-arch; a per-platform digest would break
# amd64 CI or arm64 laptops depending on which one was picked.
FROM mcr.microsoft.com/devcontainers/typescript-node:1-22-bookworm@sha256:7c2e711a4f7b02f32d2da16192d5e05aa7c95279be4ce889cff5df316f251c1d

# git and curl are already in the base image; unzip is what dprint's installer
# actually requires and is the one genuinely missing piece.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends unzip \
    && rm -rf /var/lib/apt/lists/*

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
