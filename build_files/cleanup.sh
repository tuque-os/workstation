#!/bin/bash

set -ouex pipefail
shopt -s extglob

find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -fr {} \;

# remove files with non-ascii characters
# this fixes an issue where anaconda runs ostree deploy with LANG=C
# https://github.com/blue-build/cli/issues/310
# https://github.com/JasonN3/build-container-installer/issues/150
LC_CTYPE=C fd '[^[:print:]]' --exec rm -v
