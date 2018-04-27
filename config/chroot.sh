#! /bin/sh

set -x
export LANG=C
export LC_ALL=C

PACKAGES='
nxos-desktop
lupin-casper
casper
'

PACKAGES=$(echo $PACKAGES | tr '\n' ' ')

apt-get update
apt-get install -y apt-transport-https wget ca-certificates gnupg2

wget -q https://archive.neon.kde.org/public.key -O neon.key
if echo ee86878b3be00f5c99da50974ee7c5141a163d0e00fccb889398f1a33e112584 neon.key | sha256sum -c; then
	apt-key add neon.key
	echo 'deb http://archive.neon.kde.org/dev/unstable/ bionic main' | tee /etc/apt/sources.list.d/neon-stable.list
fi
rm neon.key

wget -q http://repo.nxos.org/public.key -O nxos.key
if echo b51f77c43f28b48b14a4e06479c01afba4e54c37dc6eb6ae7f51c5751929fccc nxos.key | sha256sum -c; then
	apt-key add nxos.key
	echo 'deb http://repo.nxos.org/testing/ nxos main' | tee /etc/apt/sources.list.d/nxos-stable.list
fi
rm nxos.key

apt-get update
apt-get -qq install $PACKAGES || exit 1
apt-get clean
useradd -m -U -G sudo,cdrom,adm,dip,plugdev -p '' me
echo 'me:nitrux' | chpasswd
echo host > /etc/hostname
systemctl enable sddm
find /var/log -regex '.*?[0-9].*?' -exec rm -v {} \;
rm /etc/resolv.conf
