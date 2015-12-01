#!/bin/bash

KSAR="java -jar $HOME/java/ksar/kSar.jar"
ARG=""

if [ $# -gt 0 ]
then
    CNT=$#
    while [ $CNT -gt 0 ]
    do
	ARG="$ARG -input $1"
	shift;
	CNT=$((CNT-1))
    done
fi
echo "$KSAR $ARG"
exec $KSAR $ARG -tile -noLoadedFeedback

exit 0
