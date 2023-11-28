ARG PLATFORM=${TARGETPLATFORM}

FROM --platform=${PLATFORM} ghcr.io/bamboolabs-foundation/base-ubuntu2204:latest

## MultiArch Arguments - Required
ARG RS_NIGHTLY="nightly-2023-11-11"
ARG RS_STABLE="1.74.0"
RUN test -n "${RS_NIGHTLY:?}" && \
    test -n "${RS_STABLE:?}"

## Environment Variables - Build Arguments (Unordered)
ENV CARGO_HOME="/usr/local/cargo"
ENV CARGO_INCREMENTAL="false"
ENV CC="clang-17"
ENV CXX="clang-17"
ENV RS_NIGHTLY=${RS_NIGHTLY}
ENV RS_STABLE=${RS_STABLE}
ENV RUSTUP_HOME="/usr/local/rustup"

## Environment Variables - Build Arguments (Ordered)
ENV CARGO_BIN="${CARGO_HOME}/bin"
ENV PATH="${CARGO_BIN}${PATH:+:${PATH}}"

## Base Dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip \
    wget && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## LLVM
RUN wget -qO - https://apt.llvm.org/llvm.sh | bash -s all

## Others
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    aria2 \
    autoconf \
    automake \
    binutils-aarch64-linux-gnu \
    binutils-x86-64-linux-gnu \
    build-essential \
    cmake \
    curl \
    dirmngr \
    dpkg-dev \
    file \
    git \
    git-lfs \
    iputils-arping \
    iputils-clockdiff \
    iputils-ping \
    iputils-tracepath \
    jq \
    libbz2-dev \
    libc6-dev \
    libc6-dev-amd64-cross \
    libc6-dev-arm64-cross \
    libcurl4-openssl-dev \
    libelf-dev \
    libfuse-dev \
    libfuse3-dev \
    libgpg-error-dev \
    libgpgme-dev \
    liblzma-dev \
    libncurses-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsasl2-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libxml2-dev \
    libyaml-dev \
    libzstd-dev \
    make \
    meson \
    musl \
    musl-dev \
    musl-tools \
    nasm \
    netbase \
    ninja-build \
    openssh-client \
    patch \
    pkg-config \
    procps \
    protobuf-compiler \
    python3-dev \
    python3-pip \
    python3-wheel \
    wabt \
    xz-utils \
    yasm \
    zlib1g-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Rust
RUN export RUST_HOST="$(uname -p)-unknown-linux-gnu" && \
    curl https://sh.rustup.rs -sSf | sh -s -- \
    -y \
    --default-host ${RUST_HOST} \
    --default-toolchain ${RS_NIGHTLY} \
    --profile minimal \
    --component clippy rust-src rustfmt \
    --target \
    aarch64-apple-darwin \
    aarch64-linux-android \
    aarch64-unknown-linux-gnu \
    wasm32-unknown-emscripten \
    wasm32-unknown-unknown \
    wasm32-wasi \
    x86_64-linux-android \
    x86_64-unknown-linux-gnu && \
    rustup toolchain install ${RS_STABLE} \
    --profile minimal \
    --component clippy rust-src rustfmt \
    --target \
    aarch64-apple-darwin \
    aarch64-linux-android \
    aarch64-unknown-linux-gnu \
    wasm32-unknown-emscripten \
    wasm32-unknown-unknown \
    wasm32-wasi \
    x86_64-linux-android \
    x86_64-unknown-linux-gnu && \
    ln -s /usr/local/rustup/toolchains/${RS_NIGHTLY}-${RUST_HOST} \
    /usr/local/rustup/toolchains/nightly-${RUST_HOST} && \
    ln -s /usr/local/rustup/toolchains/${RS_STABLE}-${RUST_HOST} \
    /usr/local/rustup/toolchains/stable-${RUST_HOST}
