#!/usr/bin/env bash

ver="${fedora_version:?}.$(date +%Y%m%d)"

BUILD_ARGS=()
BUILD_ARGS+=("--build-arg" "FEDORA_MAJOR_VERSION=${fedora_version}")
BUILD_ARGS+=("--build-arg" "VERSION=${ver}")
BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")

podman build \
  "${BUILD_ARGS[@]}" \
  --pull=newer \
  --tag "${registry:?}/${image:?}:latest" \
  .
