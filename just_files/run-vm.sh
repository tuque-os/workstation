#!/usr/bin/env bash
set -euo pipefail

qemu-system-x86_64 \
  -M accel=kvm \
  -cpu host \
  -smp 6,sockets=1,dies=1,cores=6,threads=1 \
  -m 8G \
  -bios /usr/share/OVMF/OVMF_CODE.fd \
  -serial stdio \
  -device vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid="${ssh_port:?}" \
  -drive if=virtio,format=qcow2,file=output/qcow2/disk.qcow2
