#!/bin/bash

set -ouex pipefail

# copy files
rsync -rvK /ctx/system_files/ /

# run scripts
/ctx/build_files/gsettings.sh

# cleanup
/ctx/build_files/cleanup.sh

mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp

ostree container commit
