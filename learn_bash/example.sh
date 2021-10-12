#!/bin/bash

##  regex
# mac
ETH_MAC_REGEX="^([a-fA-F0-9]{2}:){5}[a-fA-F0-9]{2}$"
#IPv4
IP_REGEX='^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'
#IPv6
regex='^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$'

# getopts
while getopts 'd:Dm:f:t:' OPT; do
    case $OPT in
        d)
            DEL_DAYS="$OPTARG";;
        D)
            DEL_ORIGINAL='yes';;
        f)
            DIR_FROM="$OPTARG";;
        m)
            MAILDIR_NAME="$OPTARG";;
        t)
            DIR_TO="$OPTARG";;
        ?)
            echo "Usage: `basename $0` [options] filename"
    esac
done

# find all text file
find -type f -exec grep -Il . {} \;


# Here 文档:ENDFLAG use EOF frequently used
cat << ENDFLAG
This is a simple lookup program 
for good (and bad) restaurants
in Cape Town.
ENDFLAG