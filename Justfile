export repo_organization := env("GITHUB_REPOSITORY_OWNER", "tryton-vanmeer")
export image_name := env("IMAGE_NAME", "tuque/fedora")
export default_tag := env("DEFAULT_TAG", "latest")
export fedora_version := env("FEDORA_VERSION", "42")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")
export ssh_port := "1867"

build:
  just_files/build.sh

_rootful_load_image:
  just_files/rootful-load-image.sh

_build-bib $type $config: _rootful_load_image
  just_files/build-bib.sh

build-qcow2: build && (_build-bib "qcow2" "image.toml")

build-iso: build && (_build-bib "iso" "iso.toml")

build-vm: build-qcow2

run-vm:
  just_files/run-vm.sh

run-container:
  podman run --rm -it "${image_name}:${default_tag}" bash

vm-ssh:
  ssh fedora@vsock/{{ ssh_port }}

# check Justfile syntax
check:
  just --unstable --fmt --check -f Justfile

# Runs shellcheck on all scripts
lint:
  find . -iname "*.sh" -type f -exec shellcheck "{}" ';'

clean:
  rm -rf output
