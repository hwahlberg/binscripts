#!/bin/bash

#######################################
# 2015-11-23/ wahlberg.hakan@gmail.com
# Version 1.0
#######################################



# 1. Optional: Set new CreateDate
# 2. Rename image in directory $SRCDIR from EXIF CreateDate-tag
# 3. Move image from $SRCDIR to $DSTDIR, create target directory if missing

# if option -v (verbose), output to /dev/tty, else /dev/null
OUTPUT=/dev/null

# source directory, option -s (not used, always current directory!)
SRCDIR="."

# destination direcory, option -d.
DSTDIR="${HOME}/Photos/original"

# Files to manage, default every file in SRCDIR
files=""

# CreateDate, option -D
# Format "YYYY:MM:DD hh:mm:ss" alt "YYYY:MM:DD"

# Some flags
DO_CREATEDATE="false"
DO_RENAME="true"
DO_MOVE="false"



function help() {
    echo
    echo "imgimport.sh [-v] [-m] [-DYYYY:MM:DD [HH:MI:SS]] [-d destdir] [file(s)]"
    echo "where:"
    echo "    -v verbose"
    echo "    -m import to destdir"
    echo "    -D [YYYY:MM:DD [HH:MI:SS]] set CreateDate-tag"
    echo "    -d destdir (default ${HOME}/Photos/original)"
    echo "     [file(s)]. List of files. If empty, all files"
    echo
    echo "Files must be of mimetype (not file-extension!):"
    echo ${acceptedImages[@]}
    echo
    echo
    echo "Example 1: set CreateDate to 1980:06:01 on every file and import them to destdir"
    echo " imgimport.sh -m -D\"1980:06:01\""
    echo
    echo "Example 2: set CreateDate including time on file and import to destdir"
    echo " imgimport.sh -m -D\"1980:06:01 12:00:00\" _DSC1296.ARW"
    echo 

}






# Check if file is an image
# type should be one of:
acceptedImages=(\
"image/jpeg;" \
"image/png;" \
"image/tiff;" \
"image/gif;"\
)


function isImage() {
    local e
    type=$(file -i $1 | awk '{print $2}')
    for e in "${@:2}"
    do 
	[[ "$e" == "$type" ]] && return 0; 
    done 
    return 1;
}




while getopts ":d:s:D:vmr" opt; do
    case $opt in
	d) DSTDIR=$OPTARG
	    ;;
	m) DO_MOVE="true"
	    ;;
	r) DO_RENAME="false"
	    ;;
	s) SRCDIR=$OPTARG
	    ;;
	D) CREATEDATE=$OPTARG
	    ;;
	v) OUTPUT=/dev/tty
	    ;;
	\?) echo "Illegal option -${OPTARG}" >&2;
	    help;
	    exit 1
	    ;;
	:) echo "Option -${OPTARG} requires argument" >&2;
	    help;
	    exit 1
	    ;;
    esac
done


shift $((OPTIND-1))
#echo "2: $@"
files=$@



if [ ! -z "${CREATEDATE}" ]
then
    len=$(echo ${CREATEDATE} | wc -c)
    #echo "len=$len"
    if [ $len -eq 11 ]
    then
        CREATEDATE="${CREATEDATE} 00:00:00"
    elif [ $len -ne 20 ]
    then
        echo "Fel datum ${CREATEDATE} !"
        exit 2
    fi
    DO_CREATEDATE="true"
fi



# Main loop
#if [ x${files} = "x" ]
if [ $(echo -n ${files} | wc -c) = 0 ]
then
    files="*"
fi

newfilelist=""
for file in $files
do
    if [ -f $file ]
    then
	isImage "$file" "${acceptedImages[@]}"
	if [ $? -ne 0 ]
	then
	    echo "File $file is not an image"
	    continue
	fi
    fi
    

    # Change CreateDate?
    if [ "${DO_CREATEDATE}" = "true" ]
    then
	echo "exiftool -CreateDate=\"${CREATEDATE}\" -P -r ${file}" >${OUTPUT}
	exiftool -CreateDate="${CREATEDATE}" -P -r ${file} >${OUTPUT} 2>&1
    fi

    # Rename file(s)?
    if [ "${DO_RENAME}" = "true" ]
    then
	# use inode to keep track of file
	inode=$(ls -i $file | cut -f1 -d' ')
	echo "inode is ${inode}" >${OUTPUT} 
	echo "exiftool '-filename<CreateDate' -d %Y%m%d_%H%M%S%%-c.%%le -P -r ${file}" >${OUTPUT} 
	exiftool '-filename<CreateDate' -d %Y%m%d_%H%M%S%%-c.%%le -P -r ${file} >${OUTPUT} 2>&1 
	# we need to set "file"-variable to new name after rename
	file=$(ls -i1 * | grep ${inode} | cut -f2 -d' ')
	echo "DO_RENAME: $file" >${OUTPUT}
    fi
    
    newfilelist="$newfilelist $file"

done



# Move (import) file(s)?
if [ "${DO_MOVE}" = "true" ]
then
    echo "DO_MOVE: $newfilelist" >${OUTPUT}
    for file in $(echo ${newfilelist})
    do
	echo "exiftool  '-Directory<CreateDate' -d ${DSTDIR}/%Y/%m%d -P -r ${file}" >${OUTPUT}
	exiftool  '-Directory<CreateDate' -d ${DSTDIR}/%Y/%m%d -P  -r ${file} >${OUTPUT} 2>&1 
    done
fi

# some cleanup
if [ "${DO_CREATEDATE}" = "true" ]
then
    if [ ! -d .org ]
    then
	mkdir .org
    fi
    mv *_original .org
fi





exit 0
