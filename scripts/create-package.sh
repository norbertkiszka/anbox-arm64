#!/bin/bash

set -ex

ramdisk=$1
system=$2

if [ -z "$ramdisk" ] || [ -z "$system" ]; then
	echo "Usage: $0 <ramdisk> <system image>"
	exit 1
fi

workdir=`mktemp -d`
rootfs=$workdir/rootfs

mkdir -p $rootfs

# Extract ramdisk and preserve ownership of files
(cd $rootfs ; cat $ramdisk | gzip -d | sudo cpio -i)

mkdir $workdir/system
sudo mount -o loop,ro $system $workdir/system
sudo cp -ar $workdir/system/* $rootfs/system
sudo umount $workdir/system

gcc -o $workdir/uidmapshift external/nsexec/uidmapshift.c
sudo $workdir/uidmapshift -b $rootfs 0 100000 65536

# FIXME
sudo chmod +x $rootfs/anbox-init.sh

sudo mksquashfs $rootfs android.img -comp xz -no-xattrs
sudo chown $USER:$USER android.img

sudo mkdir -p /var/lib/anbox
sudo mv android.img /var/lib/anbox/

sudo rm -rf $workdir
