#!/bin/bash

# cleanup and commit

set -ouex pipefail
shopt -s extglob

dnf5 clean all

rm -rf /tmp/* || true
# shellcheck disable=SC2115
rm -rf /var/!(cache)
rm -rf /var/cache/!(rpm-ostree)

mkdir -p /var/tmp
chmod -R 1777 /var/tmp

ostree container commit
