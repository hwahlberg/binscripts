#!/bin/bash

MOUNTDIR="/mnt/usbdisk1"

if [ ! -d ${MOUNTDIR}/hwa ]
then
	echo "mount USB-disk1!"
	exit 1
fi


cd $HOME/Photos

for dir in \
	diabilder
	frånkamera
	gimp
	hanna
	inscannat
	LR_Backup
	original
	publicerat
	SamsungS4

do
    echo -e "\n############   \"$dir\" ..."
    rsync -avL --delete "$dir"  ${MOUNTDIR}/hwa/Photos
done

sync
sync


exit 0




