#!/usr/bin/bash
set -eoux pipefail

COPYTMP=$(mktemp -p "${PWD}" -d -t _build_podman_scp.XXXXXXXXXX)

sudo TMPDIR="${COPYTMP}" podman image scp \
  ${UID}@localhost::"${image:?}" root@localhost::"${image}"

rm -rf "${COPYTMP}"
