#!/bin/bash

# Check Tomcat Log key word ORA-00060: deadlock detected while waiting for resource
# This script is written for Nagios custom plugins
# Revision:    1.0
# Date:        2017/10/06
# Author:      Channing Liu
# Change log:
# Revision:    1.1 , WARRING display gameId , accountId , billNo 

logfile=/home/java/tomcat_task/logs/log.$(date +"%Y-%m-%d").out
logfile_filter=/tmp/task_log.txt

# Local Time before 6 mins
begin=`date +"%H:%M" --date="-6 mins"`
# Local Time
end=`date +"%H:%M"`

# Check logfile exist or not 
if [ ! -f $logfile ]
then
        echo "WARRING - $logfile is not exist  "
        exit 1;
else
        # Filiter 6 mins range to temp file
        range=`sed -n "/^$begin/,/^$end/p" $logfile > $logfile_filter`
        # grep key word
        answer=`egrep "openAward fail" $logfile_filter -A 1 | tail -n 1 | awk '{print $4,$5,$6,$7}'`
        # If grep empty is normal else abnormal
        if [[ $answer == '' ]];
                then
                        echo "OK - Task Log Normal"
                        exit 0;
        else
                        echo "CRITICAL - Task ORA-00060 $answer"
                        exit 2;
        fi
fi
