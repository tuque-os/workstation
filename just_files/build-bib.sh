#!/usr/bin/env bash
set -euo pipefail

mkdir -p "output"

echo "Cleaning up previous build"
if [[ ${type:?} == iso ]]; then
  sudo rm -rf "output/bootiso" || true
else
  sudo rm -rf "output/${type}" || true
fi

sudo podman run \
  --rm \
  -it \
  --privileged \
  --pull=newer \
  --net=host \
  --security-opt label=type:unconfined_t \
  -v "$(pwd)/${config:?}":/config.toml:ro \
  -v "$(pwd)/output":/output \
  -v /var/lib/containers/storage:/var/lib/containers/storage \
  "${bib_image:?}" \
  --type "${type}" \
  --use-librepo=True \
  --rootfs btrfs \
  "${target_image:?}"

sudo chown -R "${USER}:${USER}" output
