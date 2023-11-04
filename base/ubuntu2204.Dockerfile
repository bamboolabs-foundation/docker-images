ARG PLATFORM=${TARGETPLATFORM}

FROM --platform=${PLATFORM} ubuntu:22.04

## Environment Variables - Build Arguments
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"

## Base Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    libc6 \
    libfuse2 \
    libfuse3-3 \
    libstdc++6 \
    libzstd1 \
    tzdata \
    zlib1g && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
