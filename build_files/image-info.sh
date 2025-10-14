#!/bin/bash

set -ouex pipefail

# https://en.wikipedia.org/wiki/William_Lyon_Mackenzie_King
CODE_NAME="Lyon"

{
  echo "IMAGE_NAME=Tuque OS"
  echo "IMAGE_VARIANT=Workstation"
  echo "IMAGE_VERSION=\"${VERSION:-00.00000000}\""
  echo "IMAGE_CODE_NAME=\"${CODE_NAME}\""
  echo "IMAGE_HOME_URL=https://github.com/tuque-os/workstation"
} >>/usr/lib/os-release
