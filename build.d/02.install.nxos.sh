#! /bin/sh

build_scripts_dir=`dirname $0`
source_dir=`dirname $build_scripts_dir`

sudo mount -t proc none filesystem/proc || exit 1
sudo mount -t devtmpfs none filesystem/dev || exit 1

sudo mkdir -p /dev/pts
sudo mount -t devpts none filesystem/dev/pts || exit 1


# Install the nxos-desktop to `filesystem/`

sudo cp ${source_dir}/config/chroot.sh filesystem/
sudo chroot filesystem/ /bin/sh /chroot.sh
sudo rm -r filesystem/chroot.sh

sudo umount filesystem/dev/pts
sudo umount filesystem/dev
sudo umount filesystem/proc
