#!/bin/bash

set -ouex pipefail

mapfile -t COPR_REPOS < <(jq -r ".copr.[]" /ctx/build_files/packages.json)
mapfile -t INCLUDED_PACKAGES < <(jq -r ".include.[]" /ctx/build_files/packages.json)
mapfile -t EXCLUDED_PACKAGES < <(jq -r ".exclude.[]" /ctx/build_files/packages.json)

for copr in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$copr"
done

dnf -y remove "${EXCLUDED_PACKAGES[@]}"
dnf -y install "${INCLUDED_PACKAGES[@]}"

systemctl disable flatpak-add-fedora-repos.service
systemctl enable update-flatpaks.timer
