export repo_organization := env("GITHUB_REPOSITORY_OWNER", "tryton-vanmeer")
export image_name := env("IMAGE_NAME", "tuque/fedora")
export default_tag := env("DEFAULT_TAG", "latest")
export fedora_version := env("FEDORA_VERSION", "42")
export bib_image := env("BIB_IMAGE", "quay.io/centos-bootc/bootc-image-builder:latest")

build:
    #!/usr/bin/env bash

    # Get Version
    ver="${default_tag}-${fedora_version}.$(date +%Y%m%d)"

    BUILD_ARGS=()
    BUILD_ARGS+=("--build-arg" "MAJOR_VERSION=${fedora_version}")
    if [[ -z "$(git status -s)" ]]; then
        BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")
    fi

    podman build \
        "${BUILD_ARGS[@]}" \
        --pull=newer \
        --tag "${image_name}:${default_tag}" \
        .

_rootful_load_image:
    #!/usr/bin/bash
    set -eoux pipefail

    image="localhost/${image_name}:${default_tag}"

    ID=$(podman images --filter reference="${image}" --format "'{{ '{{.ID}}' }}'")
    ROOTFULL_ID=$(sudo podman images --filter reference="${image}" --format "'{{ '{{.ID}}' }}'")

    # load image into footful podman if latest image id not found
    if [[ $ROOTFULL_ID != $ID ]]; then
        COPYTMP=$(mktemp -p "${PWD}" -d -t _build_podman_scp.XXXXXXXXXX)
        sudo TMPDIR=${COPYTMP} podman image scp ${UID}@localhost::"${image}" root@localhost::"${image}"
        rm -rf "${COPYTMP}"
    fi

_build-bib $type $config: _rootful_load_image
    #!/usr/bin/env bash
    set -euo pipefail

    mkdir -p "output"

    echo "Cleaning up previous build"
    if [[ $type == iso ]]; then
        sudo rm -rf "output/bootiso" || true
    else
        sudo rm -rf "output/${type}" || true
    fi

    args="--type ${type} "
    args+="--use-librepo=True "
    args+="--rootfs btrfs"

    sudo podman run \
      --rm \
      -it \
      --privileged \
      --pull=newer \
      --net=host \
      --security-opt label=type:unconfined_t \
      -v $(pwd)/${config}:/config.toml:ro \
      -v $(pwd)/output:/output \
      -v /var/lib/containers/storage:/var/lib/containers/storage \
      "${bib_image}" \
      ${args} \
      "localhost/${image_name}:${default_tag}"

    sudo chown -R $USER:$USER output

build-qcow2: build && (_build-bib "qcow2" "image.toml")

build-iso: build && (_build-bib "iso" "iso.toml")

build-vm: build-qcow2

run-vm:
    #!/usr/bin/env bash
    set -euo pipefail

    qemu-system-x86_64 \
    -M accel=kvm \
    -cpu host \
    -smp 6,sockets=1,dies=1,cores=6,threads=1 \
    -m 8G \
    -bios /usr/share/OVMF/OVMF_CODE.fd \
    -serial stdio \
    -drive if=virtio,format=qcow2,file=output/qcow2/disk.qcow2

# check Justfile syntax
check:
    just --unstable --fmt --check -f Justfile

# Runs shellcheck on all scripts
lint:
    /usr/bin/find . -iname "*.sh" -type f -exec shellcheck "{}" ';'

clean:
    rm -rf output
