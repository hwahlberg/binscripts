#!/bin/bash

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
    rsync -avL --delete "$dir"  /usbbackup/home_hwa/Backup
done

sync
sync


exit 0




