export image := env("IMAGE", "localhost/tuque-os/workstation:latest")
export fedora_version := env("FEDORA_VERSION", "42")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")
export ssh_port := "1867"

test:
  echo $image

build:
  just_files/build.sh

_rootful_load_image:
  just_files/rootful-load-image.sh

_build-bib $type $config $target_image: _rootful_load_image
  just_files/build-bib.sh

build-qcow2 $target_image=(image): build && (_build-bib "qcow2" "image.toml" target_image)

build-iso $target_image=(image): build && (_build-bib "iso" "iso.toml" target_image)

build-vm: build-qcow2

run-vm:
  just_files/run-vm.sh

run-container:
  podman run --rm -it {{ image }} bash

vm-ssh:
  ssh fedora@vsock/{{ ssh_port }}

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
