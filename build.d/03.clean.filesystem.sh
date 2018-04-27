#! /bin/sh

set -x

sudo rm -rf filesystem/tmp/* \
	filesystem/boot/*.old \
	filesystem/vmlinuz*.old \
	filesystem/initrd.img*.old \
	filesystem/var/log/* \
	filesystem/var/lib/dbus/machine-id
