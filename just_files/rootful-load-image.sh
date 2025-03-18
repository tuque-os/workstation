#!/usr/bin/bash
set -eoux pipefail

IMAGE="localhost/${image_name:?}:${default_tag:?}"
COPYTMP=$(mktemp -p "${PWD}" -d -t _build_podman_scp.XXXXXXXXXX)

sudo TMPDIR="${COPYTMP}" podman image scp \
  ${UID}@localhost::"${IMAGE}" root@localhost::"${IMAGE}"

rm -rf "${COPYTMP}"
