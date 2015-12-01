#!/bin/bash

cd $HOME

for dir in \
    bin \
    Documents \
    Photos \
    Pictures 
do
    echo -e "\n############   \"$dir\" ..."
    rsync -avL --delete "$dir"  /usbbackup/home_hwa/Backup
done


exit 0




