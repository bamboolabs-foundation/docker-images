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

### [Builder - Rust LLVM 16](builder/rust-llvm16.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/base-ubuntu2204:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-rust-llvm16:latest`
* Rust Nightly   : `nightly-2023-08-08`
* Rust Stable    : `1.72.1`
* LLVM           : `16.0.6`
* GCC/G++        : `11.4.0`

### [Builder - NodeJS LTS 18](builder/rust-llvm16.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-rust-llvm16:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-node18:latest`
* NodeJS         : `18.18.2`
* NPM            : `9.8.1`
* Yarn Classic   : `1.22.19`

### [Builder - Substrate & Parity Ink](builder/rust-llvm16.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-node18:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-substrate:latest`
* Packages       :
  * [cargo-contract@3.2.0](https://github.com/paritytech/cargo-contract/releases/tag/v3.2.0)
  * [cargo-dylint@2.4.4](https://github.com/trailofbits/dylint/releases/tag/v2.4.4)
  * [dylint-link@2.4.4](https://github.com/trailofbits/dylint/releases/tag/v2.4.4)
  * [subxt-cli@0.31.0](https://github.com/paritytech/subxt/releases/tag/v0.31.0)
  * [wasm-bindgen-cli@0.2.88](https://github.com/rustwasm/wasm-bindgen/releases/tag/0.2.88)
  * [wasm-pack@0.12.1](https://github.com/rustwasm/wasm-pack/releases/tag/v0.12.1)
  * [wasmtime-cli@14.0.4](https://github.com/bytecodealliance/wasmtime/releases/tag/v14.0.4)
  * [websocat@1.12.0](https://github.com/vi/websocat/releases/tag/v1.12.0)

### [Builder - Android 28 - 33](builder/rust-llvm16.Dockerfile)

* Base Image     : `ghcr.io/bamboolabs-foundation/builder-substrate:latest`
* Image Name     : `ghcr.io/bamboolabs-foundation/builder-android18:latest`
* Android SDK    : `28 - 33`
* Android NDK    : `25.2.9519653 (25c)`
* Gradle         : `8.2.1`
