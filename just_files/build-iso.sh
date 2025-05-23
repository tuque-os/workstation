#!/usr/bin/env bash
set -eoux pipefail

HOOK_rootfs="$(realpath ./iso_files/configure_iso.sh)"
IMAGE="${registry:?}/${image:?}"
FLATPAKS=""
sudo \
  HOOK_post_rootfs="${HOOK_rootfs}" \
  just titanoboa::build \
  "$IMAGE" \
  "1" \
  "$FLATPAKS" \
  "squashfs" \
  "NONE" \
  "$IMAGE" \
  "1"

sudo chown "$(id -u):$(id -g)" output.iso
mkdir -p "./output/"
sha256sum output.iso | tee "./output/${image}.iso-CHECKSUM"
mv output.iso "./output/${image}.iso"
sudo just titanoboa::clean
