#! /bin/sh

set -x

build_scripts_dir=`dirname $0`
source_dir=`dirname $build_scripts_dir`

mkdir -p iso/casper iso/boot/isolinux

sudo cp filesystem/vmlinuz iso/boot/linux
sudo cp filesystem/initrd.img iso/boot/initramfs
sudo cp filesystem.squashfs iso/casper/filesystem.squashfs

wget -nv -nc https://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.xz
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

# Configure syslinux

cp ${source_dir}/config/syslinux.cfg iso/boot/isolinux/syslinux.cfg

wget -q -nc https://raw.githubusercontent.com/nomad-desktop/isolinux-nomad-theme/master/splash.png -O iso/boot/isolinux/splash.png
wget -q -nc https://raw.githubusercontent.com/nomad-desktop/isolinux-nomad-theme/master/theme.txt -O iso/boot/isolinux/theme.txt

cd iso/

echo -n $(sudo du -sx --block-size=1 . | tail -1 | awk '{ print $1 }') > casper/filesystem.size

cd ..

mkdir -p iso/EFI/BOOT/
grub-mkimage -o iso/EFI/BOOT/bootx64.efi -p /efi/boot -O x86_64-efi \
 fat iso9660 part_gpt part_msdos \
 normal boot linux configfile loopback chain \
 efifwsetup efi_gop efi_uga \
 ls search search_label search_fs_uuid search_fs_file \
 gfxterm gfxterm_background gfxterm_menu test all_video loadenv \
 exfat ext2 ntfs btrfs hfsplus udf


cp ${source_dir}/config/grub.cfg iso/EFI/BOOT/