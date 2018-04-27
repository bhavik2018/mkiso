#! /bin/sh

./build.d/01.make.base.filesystem.sh || exit 1

./build.d/02.install.nxos.sh || exit 1

cp filesystem/vmlinuz iso/boot/linux
cp filesystem/initrd.img iso/boot/initramfs


# Clean the filesystem.

rm -rf filesystem/tmp/* \
	filesystem/boot/* \
	filesystem/vmlinuz* \
	filesystem/initrd.img* \
	filesystem/var/log/* \
	filesystem/var/lib/dbus/machine-id


# Compress the root filesystem and create the ISO.

(sleep 300; echo +) &
echo "Compressing the root filesystem"
mksquashfs filesystem/ iso/casper/filesystem.squashfs -comp xz -no-progress


wget -q -nc https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
tar xf syslinux-6.03.tar.xz

SL=syslinux-6.03
cp $SL/bios/core/isolinux.bin \
	$SL/bios/mbr/isohdpfx.bin \
	$SL/bios/com32/menu/menu.c32 \
	$SL/bios/com32/lib/libcom32.c32 \
	$SL/bios/com32/menu/vesamenu.c32 \
	$SL/bios/com32/libutil/libutil.c32 \
	$SL/bios/com32/elflink/ldlinux/ldlinux.c32 \
	iso/boot/isolinux/

cd iso/

wget -q -nc https://raw.githubusercontent.com/nomad-desktop/isolinux-nomad-theme/master/splash.png -O boot/isolinux/splash.png
wget -q -nc https://raw.githubusercontent.com/nomad-desktop/isolinux-nomad-theme/master/theme.txt -O boot/isolinux/theme.txt

echo '
default vesamenu.c32
include theme.txt

menu title Installer boot menu.
label Try Nitrux
	kernel /boot/linux
	append initrd=/boot/initramfs boot=casper elevator=noop quiet splash

label Try Nitrux (safe graphics mode)
	kernel /boot/linux
	append initrd=/boot/initramfs boot=casper nomodeset elevator=noop quiet splash

menu tabmsg Press ENTER to boot or TAB to edit a menu entry
' > boot/isolinux/syslinux.cfg

echo -n $(du -sx --block-size=1 . | tail -1 | awk '{ print $1 }') > casper/filesystem.size

# TODO: create UEFI images.

xorriso -as mkisofs \
	-o ../nxos.iso \
	-no-emul-boot \
	-boot-info-table \
	-boot-load-size 4 \
	-c boot/isolinux/boot.cat \
	-b boot/isolinux/isolinux.bin \
	-isohybrid-mbr boot/isolinux/isohdpfx.bin \
	./
