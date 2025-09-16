mod? titanoboa

export registry := "ghcr.io/tuque-os"
export image := env("IMAGE", "workstation")
export fedora_version := env("FEDORA_VERSION", "43")

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

# run lint group
lint: lint-shell

# runs shellcheck on all scripts
[group('lint')]
lint-shell:
    fd --extension sh --type file --exec shellcheck

# verify scripts are executable
[group('lint')]
lint-bin-exec:
    #!/usr/bin/env bash
    set -e

    fd build_files iso_files just_files \
        --extension sh --type file --exec test -x

    for file in system_files/usr/bin/*; do
        test -x "$file"
    done

# watch latest gh workflow run
ci:
    gh run watch \
    $(gh run list --commit $(git rev-parse origin/HEAD) --json databaseId --jq .[].databaseId)

clean:
    rm -rf output
    sudo podman rmi "quay.io/fedora/fedora" "{{ registry }}/{{ image }}"
