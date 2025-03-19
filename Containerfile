ARG FEDORA_MAJOR_VERSION="42"
ARG SHA_HEAD_SHORT="dedbeef"
ARG VERSION=""

FROM scratch AS ctx
COPY /system_files /system_files
COPY /build_files /build_files

FROM quay.io/fedora/fedora-silverblue:${FEDORA_MAJOR_VERSION}

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    /ctx/build_files/build.sh

RUN bootc container lint
