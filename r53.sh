#!/bin/bash
# Shell Script for zone transfer to AWS R53 useing cli53 https://github.com/barnybug/cli53
# Revision:    1.0
# Date:        2017/05/05
# Author:      Channing Liu

DOMAIN=$1
DNSSERVER=127.0.0.1
GREEN_COLOR='\E[1;32m'
RED_COLOR='\E[1;31m'
RES='\E[0m'


# Check $1 not empty
if [ -z $1 ];
then
	echo -e "${RED_COLOR} Example : ./r53.sh example.com ${RES}"
	exit 1;
else
	# zon transfer to local
	dig axfr $DOMAIN @$DNSSERVER > $DOMAIN.txt
	if grep -q '; Transfer failed.' $DOMAIN.txt;
	then
		rm $DOMAIN.txt
		echo -e "${RED_COLOR}$DOMAIN Transfer failed${RES}"
		exit 1;
	else egrep -v "^$|;" $DOMAIN.txt | head -n -1  > $DOMAIN.aws && checkzone=`cli53 list |grep "$DOMAIN."|awk '{print $2}'`
		#Check AWS R53 zone available , if $checkzone 
		if [ -z $checkzone ];
		then
			echo -e "${RED_COLOR}Amazon R53 Zone not available${RES}"
			exit 1;
		else
			#Show import info , + add , - delete
			cli53 import --file $DOMAIN.aws --replace --wait --dry-run $DOMAIN
			cli53 import --file $DOMAIN.aws --replace $DOMAIN 	
		fi
	rm -f $DOMAIN.txt $DOMAIN.aws
	fi
fi
