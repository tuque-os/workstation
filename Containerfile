ARG FEDORA_MAJOR_VERSION="42"

FROM scratch AS ctx
COPY / /

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

ARG FEDORA_MAJOR_VERSION="42"
ARG SHA_HEAD_SHORT="dedbeef"
ARG VERSION=""

RUN --mount=type=bind,from=ctx,src=/,dst=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build.sh
