FROM mcr.microsoft.com/devcontainers/typescript-node:1-22-bookworm
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install git curl
RUN curl -fsSL https://dprint.dev/install.sh | DPRINT_INSTALL="/usr/local" sh
RUN which dprint
