# OpenWrt Node.js Packages Builder Image
# 
# This is a builder image for openwrt-node-packages feed.
# It contains the necessary build dependencies for compiling
# Node.js packages for OpenWrt embedded systems.
#
# Usage:
#   docker build -t openwrt-node-packages:test .
#   docker run --rm openwrt-node-packages:test echo "image ok"

FROM debian:bookworm-slim

# Set working directory
WORKDIR /workspace

# Install build dependencies required for OpenWrt SDK and Node.js package compilation
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    make \
    git \
    patch \
    python3 \
    python3-dev \
    wget \
    curl \
    ca-certificates \
    file \
    unzip \
    gawk \
    gettext \
    libncurses5-dev \
    libz-dev \
    libssl-dev \
    time \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Add a simple validation that the image is working
CMD ["echo", "OpenWrt Node.js packages builder image ready"]
