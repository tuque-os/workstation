#!/bin/bash

set -ouex pipefail

# copy files
rsync -rvK /ctx/system_files/ /
rsync --mkpath -v /ctx/cosign.pub /etc/pki/containers/ghcr.io-tuque-os-workstation.pub

# run scripts
/ctx/build_files/packages.sh
/ctx/build_files/gsettings.sh
/ctx/build_files/image-info.sh

# set default shell
sed -i "s|^SHELL=/bin/bash|SHELL=/bin/fish|" /etc/default/useradd

# cleanup
/ctx/build_files/cleanup.sh

mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp

ostree container commit
