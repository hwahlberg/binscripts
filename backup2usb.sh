#!/bin/bash


MOUNTDIR="/mnt/usbdisk2"

if [ ! -d ${MOUNTDIR}/home_hwa ]
then
        echo "mount USB-disk2!"
        exit 1
fi

cd $HOME

for dir in \
    AndroidStudioProjects \
    bin \
    Documents \
    Dropbox \
    lib \
    NetBeansProjects \
    Photos \
    PythonProjects \
    sql
do
    echo -e "\n############   \"$dir\" ..."
    rsync -avL --delete "$dir"  ${MOUNTDIR}/home_hwa/Backup
done

sync
sync


exit 0




