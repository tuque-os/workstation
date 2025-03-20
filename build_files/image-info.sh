#!/bin/bash

set -ouex pipefail

IMAGE_PRETTY_NAME="Tuque Linux"
IMAGE_NAME=Workstation
IMAGE_ID="tuque"
IMAGE_LIKE="fedora"
HOME_URL="https://github.com/tuque-os/workstation"
DOCUMENTATION_URL="https://github.com/tuque-os/workstation"
SUPPORT_URL="https://github.com/tuque-os/workstation/issues/"
CODE_NAME="Workstation-WIP"
VERSION="${VERSION:-00.00000000}"

# OS Release File
sed -i "s|^VARIANT_ID=.*|VARIANT_ID=${IMAGE_NAME,}|" /usr/lib/os-release
sed -i "s|^VARIANT=.*|VARIANT=${IMAGE_NAME}|" /usr/lib/os-release
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"${IMAGE_PRETTY_NAME} ${VERSION} (${IMAGE_NAME})|" /usr/lib/os-release
sed -i "s|^NAME=.*|NAME=\"$IMAGE_PRETTY_NAME\"|" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
sed -i "s|^DOCUMENTATION_URL=.*|DOCUMENTATION_URL=\"$DOCUMENTATION_URL\"|" /usr/lib/os-release
sed -i "s|^SUPPORT_URL=.*|SUPPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^BUG_REPORT_URL=.*|BUG_REPORT_URL=\"$SUPPORT_URL\"|" /usr/lib/os-release
sed -i "s|^CPE_NAME=\"cpe:/o:fedoraproject:fedora|CPE_NAME=\"cpe:/o:tuque-os:${IMAGE_NAME,,}|" /usr/lib/os-release
sed -i "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${IMAGE_ID,,}\"|" /usr/lib/os-release
sed -i "s|^ID=fedora|ID=${IMAGE_ID,}\nID_LIKE=\"${IMAGE_LIKE}\"|" /usr/lib/os-release
sed -i "/^REDHAT_BUGZILLA_PRODUCT=/d; /^REDHAT_BUGZILLA_PRODUCT_VERSION=/d; /^REDHAT_SUPPORT_PRODUCT=/d; /^REDHAT_SUPPORT_PRODUCT_VERSION=/d" /usr/lib/os-release
sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"$CODE_NAME\"|" /usr/lib/os-release
sed -i "s|^VERSION=.*|VERSION=\"${VERSION} (${IMAGE_NAME})\"|" /usr/lib/os-release
sed -i "s|^OSTREE_VERSION=.*|OSTREE_VERSION=\'${VERSION}\'|" /usr/lib/os-release

if [[ -n "${SHA_HEAD_SHORT:-}" ]]; then
  echo "BUILD_ID=\"$SHA_HEAD_SHORT\"" >>/usr/lib/os-release
fi

{
  echo "IMAGE_ID=\"${IMAGE_NAME}\""
  echo "IMAGE_VERSION=\"${VERSION}\""
} >>/usr/lib/os-release

# Fix issues caused by ID no longer being fedora
sed -i "s|^EFIDIR=.*|EFIDIR=\"fedora\"|" /usr/sbin/grub2-switch-to-blscfg
