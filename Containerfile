ARG MAJOR_VERSION="42"

FROM scratch AS ctx
COPY /system_files /system_files
COPY /build_files /build_files

FROM quay.io/fedora/fedora-silverblue:${MAJOR_VERSION}

RUN --mount=type=cache,dst=/var/cache/libdnf5 \
    --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    /ctx/build_files/build.sh
