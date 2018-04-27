#! /bin/sh

set -x

sudo xorriso -as mkisofs \
    -isohybrid-mbr iso/boot/isolinux/isohdpfx.bin \
    -c boot/isolinux/boot.cat \
    -b boot/isolinux/isolinux.bin \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -eltorito-alt-boot \
    -no-emul-boot \
    -isohybrid-gpt-basdat \
    -o nxos-$(date +%d-%m-%Y-%H:%M:%S).iso \
	./iso


	# -e boot/grub/efi.img \