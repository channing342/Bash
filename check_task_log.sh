#!/bin/bash

# Check Tomcat Log key word ORA-00060: deadlock detected while waiting for resource
# This script is written for Nagios custom plugins
# Revision:    1.0
# Date:        2017/10/06
# Author:      Channing Liu

logfile=/home/java/tomcat_task/logs/log.$(date +"%Y-%m-%d").out

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
        # Sed during 5 mins log & grep key word 
        answer=`sed -n "/^$begin/,/^$end/p" $logfile |egrep "ORA-00060|openAward fail"`
        # If grep empty is normal else abnormal
        if [[ $answer == '' ]];
                then
                        echo "OK - Task Log Normal"
                        #echo "$answer"
                        exit 0;
        else
                        echo "CRITICAL - Task Log ORA-00060 & openAward fail , Please contact Duty"
                        exit 2;
        fi
fi
