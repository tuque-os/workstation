#!/bin/bash

set -ouex pipefail

# cleanup
/ctx/build_files/cleanup.sh

mkdir -p /var/tmp &&
    chmod -R 1777 /var/tmp

ostree container commit
