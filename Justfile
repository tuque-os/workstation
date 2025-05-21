mod? titanoboa

export registry := "ghcr.io/tuque-os"
export image := env("IMAGE", "localhost/tuque-os/workstation:latest")
export fedora_version := env("FEDORA_VERSION", "42")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")

build:
  just_files/build.sh

build-iso $image="workstation":
  #!/usr/bin/env bash
  set -eoux pipefail

  HOOK_rootfs="$(realpath ./iso_files/configure_iso.sh)"
  IMAGE="{{ registry }}/{{ image }}"
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
  sha256sum output.iso | tee "./output/{{ image }}.iso-CHECKSUM"
  mv output.iso "./output/{{ image }}.iso"
  sudo just titanoboa::clean

_rootful_load_image:
  just_files/rootful-load-image.sh

_build-bib $type $config $target_image: _rootful_load_image
  just_files/build-bib.sh

build-qcow2 $target_image=(image): build && (_build-bib "qcow2" "image.toml" target_image)

build-vm: build-qcow2

run-vm image="workstation":
  gnome-boxes output/{{ image }}.iso &

run-container:
  podman run --rm -it {{ image }} bash

# check Justfile syntax
check:
  just --unstable --fmt --check -f Justfile

# runs shellcheck on all scripts
lint:
  fd --extension sh --type file --exec shellcheck

# watch latest gh workflow run
ci:
  gh run watch \
  $(gh run list --commit $(git rev-parse origin/HEAD) --json databaseId --jq .[].databaseId)

clean:
  rm -rf output
