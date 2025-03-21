#!/bin/bash

set -ouex pipefail

# test gschema overrides for errors
mkdir -p /tmp/schema-test
find /usr/share/glib-2.0/schemas/ -type f ! -name "*.gschema.override" -exec cp {} /tmp/schema-test/ \;
cp /usr/share/glib-2.0/schemas/zz0-tuque-workstation.gschema.override /tmp/schema-test/

glib-compile-schemas --strict /tmp/schema-test

# if there are not errors, proceed with compiling custom override gschema
glib-compile-schemas /usr/share/glib-2.0/schemas &>/dev/null

systemctl enable dconf-update.service
