MAKEFLAGS			+=	--jobs 1 --environment-overrides
SHELL				:=	/bin/bash
CPU_ARCH			:=	$(shell if [[ "$(shell uname -p)" = "x86_64" ]]; then echo amd64; else echo arm64; fi)
BUILDX_BUILDER_NAME		:=	buildx-multiarch-builder
BUILDX_PLATFORM_ARM64		:=	linux/arm64
BUILDX_PLATFORM_AMD64		:=	linux/amd64
BUILDX_PLATFORMS		:=	${BUILDX_PLATFORM_ARM64},${BUILDX_PLATFORM_AMD64}
ORG_NAME			:=	bamboolabs-foundation
REPO_NAME			:=	docker-images
TAG_PREFIX			:=	ghcr.io/${ORG_NAME}

.PHONY: all check push
.PHONY: prepare clean
.PHONY: check-base-ubuntu2204 push-base-ubuntu2204
.PHONY: check-base push-base
.PHONY: check-builder push-builder
.PHONY: check-builder-rust-llvm push-builder-rust-llvm
.PHONY: check-builder-node18 push-builder-node18
.PHONY: check-builder-substrate push-builder-substrate
.PHONY: check-builder-android28 push-builder-android28
.ONESHELL: all check
.ONESHELL: prepare clean
.ONESHELL: check-base-ubuntu2204 push-base-ubuntu2204
.ONESHELL: check-base push-base
.ONESHELL: check-builder push-builder
.ONESHELL: check-builder-rust-llvm push-builder-rust-llvm
.ONESHELL: check-builder-node18 push-builder-node18
.ONESHELL: check-builder-substrate push-builder-substrate
.ONESHELL: check-builder-android28 push-builder-android28

all: | push

push: | push-base push-builder

push-base: | push-base-ubuntu2204

push-builder: | push-builder-rust-llvm push-builder-node18 push-builder-substrate push-builder-android28

check: | check-base check-builder

check-base: | check-base-ubuntu2204

check-builder: | check-builder-rust-llvm check-builder-node18 check-builder-substrate check-builder-android28

clean:
	@echo -e "\033[92m\nUninstalling Docker BuildX MultiArch Binary Format...\033[0m"
	@(docker run --privileged --rm tonistiigi/binfmt --uninstall *)
	@echo -e "\033[92m\nRemoving Docker BuildX Builder for MultiArch...\033[0m"
	@(docker buildx prune --force)
	@(docker buildx rm ${BUILDX_BUILDER_NAME} | true)

prepare:
	@echo -e "\033[92m\nInstalling Docker BuildX MultiArch Binary Format...\033[0m"
	@(docker run --privileged --rm tonistiigi/binfmt --install all)
	@echo -e "\033[92m\nConfiguring Docker BuildX Builder for MultiArch...\033[0m"
	@(docker buildx create --name ${BUILDX_BUILDER_NAME} --driver docker-container --bootstrap --use > /dev/null 2>&1) || true
	@echo -e "\033[34m\nDocker BuildX Builder for MultiArch Configured ("${BUILDX_BUILDER_NAME}")\033[0m"

push-base-ubuntu2204: | prepare
	@echo -e "\033[92m\nBuilding Docker Image - Base Ubuntu 22.04\033[0m"
	@$(eval ANNOTATIONS=$(shell cat annotation-base.txt | tr -d '\n'))
	@$(eval ANNOTATIONS=${ANNOTATIONS}"Base image based on Ubuntu 22.04 LTS (Jammy)")
	docker buildx build \
		-t ${TAG_PREFIX}/base-ubuntu2204:latest \
		-f base/ubuntu2204.Dockerfile \
		--pull \
		--platform ${BUILDX_PLATFORMS} \
		--output type=registry,${ANNOTATIONS} \
		.

push-builder-rust-llvm: | push-base-ubuntu2204
	@echo -e "\033[92m\nBuilding Docker Image - Builder Rust LLVM\033[0m"
	@$(eval ANNOTATIONS=$(shell cat annotation-base.txt | tr -d '\n'))
	@$(eval ANNOTATIONS=${ANNOTATIONS}"Builder image for Rust with LLVM")
	docker buildx build \
		-t ${TAG_PREFIX}/builder-rust-llvm:latest \
		-f builder/rust-llvm.Dockerfile \
		--pull \
		--platform ${BUILDX_PLATFORMS} \
		--output type=registry,${ANNOTATIONS} \
		.

push-builder-node18: | push-builder-rust-llvm
	@echo -e "\033[92m\nBuilding Docker Image - Builder NodeJS LTS 18\033[0m"
	@$(eval ANNOTATIONS=$(shell cat annotation-base.txt | tr -d '\n'))
	@$(eval ANNOTATIONS=${ANNOTATIONS}"NodeJS LTS 18 builder image")
	docker buildx build \
		-t ${TAG_PREFIX}/builder-node18:latest \
		-f builder/node18.Dockerfile \
		--pull \
		--platform ${BUILDX_PLATFORMS} \
		--output type=registry,${ANNOTATIONS} \
		.

push-builder-substrate: | push-builder-node18
	@echo -e "\033[92m\nBuilding Docker Image - Builder Substrate & Parity Ink!\033[0m"
	@$(eval ANNOTATIONS=$(shell cat annotation-base.txt | tr -d '\n'))
	@$(eval ANNOTATIONS=${ANNOTATIONS}"Substrate polkadot-v1.0.0 & Parity Ink! builder image")
	docker buildx build \
		-t ${TAG_PREFIX}/builder-substrate:latest \
		-f builder/substrate.Dockerfile \
		--pull \
		--platform ${BUILDX_PLATFORMS} \
		--output type=registry,${ANNOTATIONS} \
		.

push-builder-android28: | push-builder-substrate
	@echo -e "\033[92m\nBuilding Docker Image - Builder Android (28-33)\033[0m"
	@$(eval ANNOTATIONS=$(shell cat annotation-base.txt | tr -d '\n'))
	@$(eval ANNOTATIONS=${ANNOTATIONS}"Android builder image for Platform 28-33")
	docker buildx build \
		-t ${TAG_PREFIX}/builder-android28:latest \
		-f builder/android28.Dockerfile \
		--pull \
		--platform ${BUILDX_PLATFORM_AMD64} \
		--output type=registry,${ANNOTATIONS} \
		.

check-base-ubuntu2204:
	@echo -e "\033[92m\nChecking Docker Image - Base Ubuntu 22.04\033[0m"
	DOCKER_BUILDKIT=0 docker build \
		-t ${TAG_PREFIX}/base-ubuntu2204:latest \
		-f base/ubuntu2204.Dockerfile \
		--build-arg PLATFORM=${BUILDX_PLATFORM_AMD64} \
		.

check-builder-rust-llvm: | check-base-ubuntu2204
	@echo -e "\033[92m\nChecking Docker Image - Builder Rust LLVM\033[0m"
	DOCKER_BUILDKIT=0 docker build \
		-t ${TAG_PREFIX}/builder-rust-llvm:latest \
		-f builder/rust-llvm.Dockerfile \
		--build-arg PLATFORM=${BUILDX_PLATFORM_AMD64} \
		.

check-builder-node18: | check-builder-rust-llvm
	@echo -e "\033[92m\nChecking Docker Image - Builder NodeJS LTS 18\033[0m"
	DOCKER_BUILDKIT=0 docker build \
		-t ${TAG_PREFIX}/builder-node18:latest \
		-f builder/node18.Dockerfile \
		--build-arg PLATFORM=${BUILDX_PLATFORM_AMD64} \
		.

check-builder-substrate: | check-builder-node18
	@echo -e "\033[92m\nChecking Docker Image - Builder Substrate & Parity Ink!\033[0m"
	DOCKER_BUILDKIT=0 docker build \
		-t ${TAG_PREFIX}/builder-substrate:latest \
		-f builder/substrate.Dockerfile \
		--build-arg PLATFORM=${BUILDX_PLATFORM_AMD64} \
		.

check-builder-android28: | check-builder-substrate
	@echo -e "\033[92m\nChecking Docker Image - Builder Android (28-33)\033[0m"
	DOCKER_BUILDKIT=0 docker build \
		-t ${TAG_PREFIX}/builder-android28:latest \
		-f builder/android28.Dockerfile \
		.
