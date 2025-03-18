#!/usr/bin/env bash

IMAGE_VERSION="${fedora_version:?}.$(date +%Y%m%d)-$(git rev-parse --short HEAD)"

BUILD_ARGS=()
BUILD_ARGS+=("--build-arg" "MAJOR_VERSION=${fedora_version}")
BUILD_ARGS+=("--build-arg" "IMAGE_VERSION=${IMAGE_VERSION}")

podman build \
  "${BUILD_ARGS[@]}" \
  --pull=newer \
  --tag "${image_name:?}:${default_tag:?}" \
  .
