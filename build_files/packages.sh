#!/bin/bash

set -ouex pipefail

mapfile -t COPR_REPOS < <(jq -r ".copr.[]" /ctx/build_files/packages.json)
mapfile -t INCLUDED_PACKAGES < <(jq -r ".include.[]" /ctx/build_files/packages.json)
mapfile -t EXCLUDED_PACKAGES < <(jq -r ".exclude.[]" /ctx/build_files/packages.json)

# RPM Fusion repo
dnf -y install \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

# codecs and hardware acceleration
dnf -y swap ffmpeg-free ffmpeg --allowerasing
dnf -y install intel-media-driver
dnf -y swap mesa-va-drivers mesa-va-drivers-freeworld
dnf -y swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

for copr in "${COPR_REPOS[@]}"; do
  dnf5 -y copr enable "$copr"
done

dnf -y remove "${EXCLUDED_PACKAGES[@]}"
dnf -y install "${INCLUDED_PACKAGES[@]}"

systemctl disable flatpak-add-fedora-repos.service
systemctl enable update-flatpaks.timer

# remove Fedora Firefox prefs
rm /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
