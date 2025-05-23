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
mv output.iso "./output/${image}.iso"
sha256sum "./output/${image}.iso" | tee "./output/${image}.iso-CHECKSUM"
sudo just titanoboa::clean
