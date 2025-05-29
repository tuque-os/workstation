#!/bin/bash

set -ouex pipefail
shopt -s extglob

find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -fr {} \;
