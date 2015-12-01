#!/bin/bash


for file in \
    bin \
    Dropbox \
    NetBeansProjects \
    "SpiderOak Hive"
do
    echo -e "\n############   \"$file\" ..."
    rsync -av --delete "$file"  /usbdisk/hwa/Backup/
done


exit 0




