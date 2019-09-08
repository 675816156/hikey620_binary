#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "$0 <AOSP|Debian> </dev/ttyUSBx>"
	exit -1
fi

if [[ ! -e $2 ]]; then
	echo "$2 not exists"
	exit -1
fi

sudo python   hisi-idt.py -d $2 --img1 ./recovery.bin

case $1 in
	AOSP)
		echo updating AOSP
		sudo fastboot flash ptable   $1/ptable-aosp-8g.img
		sudo fastboot flash loader   l-loader.bin
		sudo fastboot flash fastboot fip.bin
		sudo fastboot flash nvme     nvme.img
		sudo fastboot update         $1/image-hikey-3606021.zip
		;;
	Debian)
		echo Debian
		sudo fastboot flash ptable   $1/ptable-linux-8g.img
		sudo fastboot flash loader   l-loader.bin
		sudo fastboot flash fastboot fip.bin
		sudo fastboot flash nvme     nvme.img
		sudo fastboot flash boot     $1/boot-linaro-stretch-developer-hikey-20190720-33.img
		sudo fastboot flash system   $1/rootfs-linaro-stretch-developer-hikey-20190720-33.img
		;;
esac
sudo fastboot reboot

