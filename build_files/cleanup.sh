#!/bin/bash

set -ouex pipefail

# clean package manager cache
dnf5 clean all

# clean temporary files
rm -rf /tmp/* || true
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;
