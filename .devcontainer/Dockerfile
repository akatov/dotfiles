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
ARG DPRINT_VERSION=0.55.2
RUN curl -fsSL https://dprint.dev/install.sh | DPRINT_INSTALL="/usr/local" sh -s -- "${DPRINT_VERSION}" \
    && dprint --version

# chezmoi: installed here rather than via the devcontainer feature. The feature
# defaults to version "latest" and its install script may run apt-get update,
# so its layer both drifts and costs ~30s on every rebuild. Pinning it here
# keeps it in sync with .chezmoiversion. Placed last so a bump doesn't
# re-download dprint. Each command self-verifies by running the binary --
# `which` would only prove a file landed, not that it matches the platform.
ARG CHEZMOI_VERSION=2.72.0
RUN ARCH=$(dpkg --print-architecture) \
    && curl -fsSL "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_${ARCH}.tar.gz" \
      -o /tmp/chezmoi.tar.gz \
    && tar -xzf /tmp/chezmoi.tar.gz -C /tmp chezmoi \
    && install /tmp/chezmoi /usr/local/bin/chezmoi \
    && rm /tmp/chezmoi /tmp/chezmoi.tar.gz \
    && chezmoi --version
