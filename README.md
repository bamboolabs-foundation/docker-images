# BambooLabs Foundations - Docker Images

All shared docker images for all BambooLabs's R&D sofwares/services.

## Supported CPU Architectures

Either `x86_64 (amd64)` or `aarch64 (arm64)`, except for `Android Builder (amd64 only)`.

## [Base](base/README.md)

### [Base - Ubuntu 22.04](base/ubuntu2204.Dockerfile)

* Base Image     : `ubuntu:22.04`
* Image Name     : `ghcr.io/bamboolabs-foundation/base-ubuntu2204:latest`
* GNU C Library  : `2.35`
* Extra Packages : `libfuse2`, `libfuse3-3`

## [Builder](builder/README.md)

### [Builder - Rust LLVM](builder/rust-llvm.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/base-ubuntu2204:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-rust-llvm:latest`
* Rust Nightly   : `nightly-2024-04-22`
* Rust Stable    : `1.78.0`
* LLVM           : `18.1.3`
* GCC/G++        : `11.4.0`

### [Builder - NodeJS LTS 18](builder/node18.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-rust-llvm:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-node18:latest`
* NodeJS         : `18.20.2`
* NPM            : `10.5.0`
* Yarn Classic   : `1.22.22`

### [Builder - Substrate & Parity Ink](builder/substrate.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-node18:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-substrate:latest`
* Packages       :
  * [cargo-contract@4.1.1](https://github.com/paritytech/cargo-contract/releases/tag/v4.1.1)
  * [cargo-dylint@3.1.0](https://github.com/trailofbits/dylint/releases/tag/v3.1.0)
  * [subxt-cli@0.35.3](https://github.com/paritytech/subxt/releases/tag/v0.35.3)
  * [wasm-bindgen-cli@0.2.92](https://github.com/rustwasm/wasm-bindgen/releases/tag/0.2.92)
  * [wasm-pack@0.12.1](https://github.com/rustwasm/wasm-pack/releases/tag/v0.12.1)
  * [wasmtime-cli@20.0.2](https://github.com/bytecodealliance/wasmtime/releases/tag/v20.0.2)

### [Builder - Android 28 - 34](builder/android28.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-substrate:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-android28:latest`
* Android SDK    : `28 - 34`
* Android NDK    : `26.3.11579264 (26d)`
* Gradle         : `8.4`
