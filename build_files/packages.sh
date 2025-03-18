#!/bin/bash

set -ouex pipefail

mapfile -t INCLUDED_PACKAGES < <(jq -r ".include.[]" /ctx/build_files/packages.json)
mapfile -t EXCLUDED_PACKAGES < <(jq -r ".exclude.[]" /ctx/build_files/packages.json)

dnf -y remove "${EXCLUDED_PACKAGES[@]}"
dnf -y install "${INCLUDED_PACKAGES[@]}"
