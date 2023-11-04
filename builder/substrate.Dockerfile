FROM --platform=${TARGETPLATFORM} ghcr.io/bamboolabs-foundation/builder-node18:latest

## MultiArch Arguments - Required
ARG TARGETARCH
ARG TARGETPLATFORM
RUN test -n "${TARGETARCH:?}" && \
    test -n "${TARGETPLATFORM:?}"

## Prebuilt binaries
COPY prebuilt/${TARGETPLATFORM}/* ${CARGO_HOME}/bin/
