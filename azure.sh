#!/bin/bash
# Shell Script for zone transfer to Azure DNS useing officail  Azure CLI 2.0 https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
# Revision:    1.0
# Date:        2017/05/07
# Author:      Channing Liu

DOMAIN=$1
DNSSERVER=127.0.0.1
GREEN_COLOR='\E[1;32m'
RED_COLOR='\E[1;31m'
RES='\E[0m'


# Check $1 not empty
if [ -z $1 ];
then
	echo -e "${RED_COLOR} Example : ./azure.sh example.com ${RES}"
	exit 1;
else
	# zon transfer to local
	dig axfr $DOMAIN @$DNSSERVER > $DOMAIN.txt
	if grep -q '; Transfer failed.' $DOMAIN.txt;
	then
		rm $DOMAIN.txt
		echo -e "${RED_COLOR}$DOMAIN Transfer failed${RES}"
		exit 1;
	else egrep -v "^$|;" $DOMAIN.txt | head -n -1  > $DOMAIN.azure && checkzone=`az network dns zone list -o table |grep "$DOMAIN"|awk '{print $1}'`
		#Check Azure DNS zone available , if $checkzone 
		if [ -z $checkzone ];
		then
			echo -e "${RED_COLOR}Azure DNS zone is not available${RES}"
			exit 1;
		else
			# Azure DNS import is overwrite mode so u don't need compare diff 
			az network dns zone import -g dns  -n $DOMAIN -f $DOMAIN.azure	
		fi
	rm -f $DOMAIN.txt $DOMAIN.azure
	fi
fi
