#!/bin/bash
FLAC=$1
MP3="${FLAC%.flac}.mp3"
[ -r "$FLAC" ] || { echo can not read file \"$FLAC\" >&1 ; exit 1 ; } ;
metaflac --export-tags-to=- "$FLAC" | sed 's/=\(.*\)/="\1"/' >tmp.tmp
cat tmp.tmp
. tmp.tmp
rm tmp.tmp
flac -dc "$FLAC" | lame -b 128 -h --tt "$Title" \
--tn "$Tracknumber" \
--tg "$Genre" \
--ty "$Date" \
--ta "$Artist" \
--tl "$Album" \
--add-id3v2 \
- "$MP3"
