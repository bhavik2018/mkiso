#! /bin/sh

set -x

BASE_FILE_SYSTEM_URL="http://cdimage.ubuntu.com/ubuntu-base/daily/current/bionic-base-amd64.tar.gz"

sudo mkdir -p \
        filesystem/dev \
        filesystem/proc


wget -c -nv  ${BASE_FILE_SYSTEM_URL} || { echo "ERROR: Unable to get bionic-base-amd64!" && exit 1; }

sudo tar xf *.tar.gz -C filesystem || exit 1

sudo rm -rf filesystem/dev/*
