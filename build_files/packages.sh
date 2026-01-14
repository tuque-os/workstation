#!/bin/bash

set -ouex pipefail

mapfile -t COPR_REPOS < <(jq -r ".copr.[]" /ctx/build_files/packages.json)
mapfile -t INCLUDED_PACKAGES < <(jq -r ".include.[]" /ctx/build_files/packages.json)
mapfile -t EXCLUDED_PACKAGES < <(jq -r ".exclude.[]" /ctx/build_files/packages.json)

for copr in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$copr"
done

dnf install \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

dnf -y remove "${EXCLUDED_PACKAGES[@]}"
dnf -y install "${INCLUDED_PACKAGES[@]}"

systemctl disable flatpak-add-fedora-repos.service
systemctl enable update-flatpaks.timer
