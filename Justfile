mod? titanoboa

export registry := "ghcr.io/tuque-os"
export image := env("IMAGE", "workstation")
export fedora_version := env("FEDORA_VERSION", "42")

build:
  just_files/build.sh

build-iso:
  just_files/build-iso.sh

run-vm:
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
  sudo podman rmi "quay.io/fedora/fedora" "{{ registry }}/{{ image }}"
