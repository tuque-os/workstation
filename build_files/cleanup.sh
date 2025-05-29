#!/bin/bash

set -ouex pipefail

# clean package manager cache
dnf5 clean all

# clean temporary files
rm -rf /tmp/*
# shellcheck disable=SC2115
rm -rf /var/*

# Restore and setup directories
mkdir -p /tmp
mkdir -p /var/tmp \
&& chmod -R 1777 /var/tmp
