# Builder Images

These images are commonly used for `build stage` in `multi-stage` docker build, the base images for `production stage` are located in [base](../base/README.md).

## Image Dependencies

1. [Builder - Rust LLVM 16](./rust-llvm16.Dockerfile) <- [Base - Ubuntu 22.04](../base/ubuntu2204.Dockerfile)
2. [Builder - NodeJS LTS 18](./node18.Dockerfile) <- [Builder - Rust LLVM 16](./rust-llvm16.Dockerfile)
3. [Builder - Substrate & Parity Ink!](./substrate.Dockerfile) <- [Builder - NodeJS LTS 18](./node18.Dockerfile)
4. [Builder - Android 28 - 33](./android28.Dockerfile) <- [Builder - Substrate & Parity Ink!](./substrate.Dockerfile)

## Image Tags

### 1. Builder - Rust LLVM 16

```plain
ghcr.io/bamboolabs-foundation/builder-rust-llvm16:latest
```

### 2. Builder - NodeJS LTS 18

```plain
ghcr.io/bamboolabs-foundation/builder-node18:latest
```

### 3. Builder - Substrate & Parity Ink

```plain
ghcr.io/bamboolabs-foundation/builder-substrate:latest
```

### 4. Builder - Android 28 - 33

```plain
ghcr.io/bamboolabs-foundation/builder-android18:latest
```
