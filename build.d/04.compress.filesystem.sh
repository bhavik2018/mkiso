#! /bin/sh

set -x

(sleep 300; echo +) &

echo "Compressing the root filesystem"
sudo mksquashfs filesystem filesystem.squashfs -comp xz
