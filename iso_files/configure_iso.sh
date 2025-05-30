#!/usr/bin/env bash

set -eoux pipefail

# TODO: write image-info.json in container build so this can be dynamic
# https://github.com/ublue-os/bluefin/blob/main/iso_files/configure_iso_anaconda.sh
IMAGE_REF="ghcr.io/tuque-os/workstation:latest"

# install Anaconda
dnf install -y anaconda-live anaconda-webui libblockdev-{btrfs,lvm,dm}

# Anaconda profile
tee /etc/anaconda/profile.d/tuque.conf <<EOF
# Anaconda configuration file for TuqueOS

[Profile]
# Define the profile.
profile_id = tuque

[Profile Detection]
# Match os-release values
os_id = tuque

[Network]
default_on_boot = FIRST_WIRED_WITH_LINK

[Bootloader]
efi_dir = fedora
menu_auto_hide = True

[Storage]
default_scheme = BTRFS
btrfs_compression = zstd:1
default_partitioning =
    /     (min 1 GiB, max 70 GiB)
    /home (min 500 MiB, free 50 GiB)
    /var  (btrfs)

[User Interface]
custom_stylesheet = /usr/share/anaconda/pixmaps/silverblue/fedora-silverblue.css
hidden_spokes =
    NetworkSpoke
    PasswordSpoke
    UserSpoke
hidden_webui_pages =
    anaconda-screen-accounts

[Localization]
use_geolocation = False
EOF

# default kickstart
cat <<EOF >>/usr/share/anaconda/interactive-defaults.ks
ostreecontainer --url=${IMAGE_REF} --transport=containers-storage --no-signature-verification
%include /usr/share/anaconda/post-scripts/install-configure-upgrade.ks
%include /usr/share/anaconda/post-scripts/disable-fedora-flatpak.ks
EOF

# signed images
cat <<EOF >>/usr/share/anaconda/post-scripts/install-configure-upgrade.ks
%post --erroronfail
bootc switch --mutate-in-place --enforce-container-sigpolicy --transport registry ${IMAGE_REF}
%end
EOF

# disable Fedora flatpak repo
cat <<EOF >>/usr/share/anaconda/post-scripts/disable-fedora-flatpak.ks
%post --erroronfail
systemctl disable flatpak-add-fedora-repos.service
%end
EOF

# set Anaconda payload to use flathub
cat <<EOF >>/etc/anaconda/conf.d/anaconda.conf
[Payload]
flatpak_remote = flathub https://dl.flathub.org/repo/
EOF
