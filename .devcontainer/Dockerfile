# Use an official node image as a parent image
FROM node:20

# Set environment variables for versions
ARG HUGO_VERSION=0.126.1
ARG GO_VERSION=1.22.3

# Install build and runtime dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl git openssl && \
    rm -rf /var/lib/apt/lists/*

# Download architecture-specific Hugo and Go releases. node:20 is multi-arch, so
# resolve the download architecture at build time for both Apple Silicon and x86 hosts.
RUN set -eux; \
    case "$(uname -m)" in \
        aarch64|arm64) ARCH=arm64 ;; \
        x86_64|amd64) ARCH=amd64 ;; \
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;; \
    esac; \
    curl --fail --location --retry 3 --output /tmp/hugo.tar.gz \
        "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${ARCH}.tar.gz"; \
    tar -xzf /tmp/hugo.tar.gz -C /tmp hugo; \
    install -m 0755 /tmp/hugo /usr/local/bin/hugo; \
    rm -f /tmp/hugo.tar.gz /tmp/hugo; \
    curl --fail --location --retry 3 --output /tmp/go.tar.gz \
        "https://dl.google.com/go/go${GO_VERSION}.linux-${ARCH}.tar.gz"; \
    tar -C /usr/local -xzf /tmp/go.tar.gz; \
    ln -sf /usr/local/go/bin/go /usr/local/bin/go; \
    rm -f /tmp/go.tar.gz; \
    hugo version; \
    /usr/local/go/bin/go version

# Export Go path
ENV PATH="/usr/local/go/bin:${PATH}"
