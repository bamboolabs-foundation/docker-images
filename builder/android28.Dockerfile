FROM --platform=${TARGETPLATFORM} ghcr.io/bamboolabs-foundation/builder-substrate:latest

## MultiArch Arguments - Required
ARG TARGETARCH
ARG TARGETPLATFORM
ARG GRADLE_VERSION="8.2.1"
ARG NDK_VERSION="25.2.9519653"
ARG SDKMANAGER_VERSION="9477386_latest"
RUN test -n "${TARGETARCH:?}" && \
    test -n "${TARGETPLATFORM:?}"

## Environment Variables - Android specific
ENV ANDROID_HOME="/opt/android"
ENV GRADLE_FILE="gradle-${GRADLE_VERSION}-bin.zip"
ENV GRADLE_HOME="/opt/gradle"
ENV GRADLE_USER_HOME="${GRADLE_HOME}"
ENV GRADLE_PATH="${GRADLE_HOME}/gradle-${GRADLE_VERSION}/bin"
ENV NDK_PATH="${ANDROID_HOME}/ndk/${NDK_VERSION}/toolchains/llvm/prebuilt/linux-x86_64/bin"
ENV SDKMANAGER_DIR="${ANDROID_HOME}/cmdline-tools"
ENV SDKMANAGER_FILE="commandlinetools-linux-${SDKMANAGER_VERSION}.zip"
ENV SDKMANAGER_PATH="${SDKMANAGER_DIR}/latest/bin"
ENV PATH="${NDK_PATH}:${GRADLE_PATH}:${SDKMANAGER_PATH}:${PATH}"

## OpenJDK
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libgl1 \
    libtcmalloc-minimal4 \
    libicu-dev \
    openjdk-11-jdk-headless \
    openjdk-17-jdk-headless \
    ruby \
    ruby-dev \
    shellcheck && \
    gem install bundler && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Gradle
RUN mkdir -p ${GRADLE_HOME} && \
    cd ${GRADLE_HOME} && \
    wget -q --progress=dot:mega "https://services.gradle.org/distributions/${GRADLE_FILE}" && \
    unzip "${GRADLE_FILE}" && \
    rm "${GRADLE_FILE}"

## SDK Manager
RUN mkdir -p ${SDKMANAGER_DIR} && \
    cd ${SDKMANAGER_DIR} && \
    wget -q --progress=dot:mega "https://dl.google.com/android/repository/${SDKMANAGER_FILE}" && \
    unzip "${SDKMANAGER_FILE}" && \
    mv cmdline-tools latest && \
    rm "${SDKMANAGER_FILE}"

## SDK 28-33 Install, NDK 25c, Build Tools
RUN yes | sdkmanager "ndk;${NDK_VERSION}" \
    "build-tools;30.0.3" \
    "build-tools;33.0.2" && \
    i=28 && \
    while [ ${i} -ne 34 ]; \
    do \
    yes | sdkmanager "platforms;android-${i}"; \
    i=$(($i+1)); \
    done
