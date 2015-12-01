#!/bin/bash


SEARCH1="CN"
SEARCH2="*"
while getopts "S" OPTION
do
    case $OPTION in
	S)
	    SEARCH1="sAMAccountName";
	    SEARCH2="";
	    ;;
    esac
done

shift $(($OPTIND - 1))

if [ $# -lt 1 ]
then
    echo "Need CN or sAMAccountName to search"
    exit 2
fi

ldapsearch -LLL -x -b OU=Boliden,DC=boliden,DC=internal -h boldcr0003.boliden.internal "(${SEARCH1}=${1}${SEARCH2})"

exit 0
