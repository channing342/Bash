#!/bin/bash

# Check log key word 'QNG device not found or already in use'
# This script is written for Nagios custom plugins
# Revision:    1.0
# Date:        2017/07/20
# Author:      Channing Liu

logfile=/mnt/$1/main.log

# Local Time before 6 mins
begin=`date +"%Y-%m-%d %H:%M" --date="-6 mins"`
# Local Time
end=`date +"%Y-%m-%d %H:%M"`

# Check $1 empty
if [ -z $1 ];
then
        echo "WARRING - Example : ./check_log_RNG RNG221"
        exit 1;
# Check logfile exist or not 
elif [ ! -f $logfile ]
then
        echo "WARRING - $logfile is not exist  "
        exit 1;
else
        # Sed during 5 mins log & grep key word 
        answer=`sed -n "/^$begin/,/^$end/p" $logfile |grep 'QNG device not found or already in use'`
        # If grep empty is normal else abnormal
        if [[ $answer == '' ]];
                then
                        echo "OK - $1 is Normal"
                        echo "$answer"
                        exit 0;
        else
                        echo "CRITICAL - $1 , QNG device not found or already in use"
                        exit 2;
        fi
fi
