ARG PLATFORM=${TARGETPLATFORM}

FROM --platform=${PLATFORM} ghcr.io/bamboolabs-foundation/builder-node18:latest

ARG PLATFORM=${TARGETPLATFORM}

## Prebuilt binaries
COPY prebuilt/${PLATFORM}/* ${CARGO_HOME}/bin/
