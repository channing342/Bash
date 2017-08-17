#!/bin/bash
# Nagios scipt using redis-cli collect info and list Slowlog
# Date:			2017/08/16
# Author:		Channing Liu	channing342@gmail.com
# Version:		v1.0

# CONFIG SET slowlog-log-slower-than 10000
# CONFIG GET slowlog-log-slower-than
# CONFIG SET slowlog-max-len 1024
# CONFIG GET slowlog-max-len
# SLOWLOG GET
# SLOWLOG LEN
# SLOWLOG RESET

# Return codes:
# STATE_OK=0
# STATE_WARNING=1
# STATE_CRITICAL=2
# STATE_UNKNOWN=3

ARG1="$1"
IP="$2"
ARG3="$3"
PORT="$4"

function showloglen()
{
	LEN=`/usr/local/bin/redis-cli -h $IP -p $PORT --raw  SLOWLOG LEN`
}

function slowlogget()
{
	result=`/usr/local/bin/redis-cli -h $IP -p $PORT --raw SLOWLOG GET | egrep 'GET|SET|KEYS|SCAN' -C 1`
}

function slowlogreset()
{
	/usr/local/bin/redis-cli -h $IP -p $PORT SLOWLOG RESET
} 

function checkenv()
{
			if [ -z $IP ]; then
				echo 'WARRING - Missing Host IP';
				exit 1;
			elif [ -z $ARG3 ] || [ '-p' != $ARG3 ]; then
				echo 'WARRING - Missing ARG -p';
				exit 1;
			elif [ -z $PORT ]; then
				echo 'WARRING - Missing Port';
				exit 1;
			else
				return
			fi
}

function usage()
{
    echo
    echo "  Scipt is using redis-cli collect info and list Slowlog"
    echo
    echo " -h      : Display this help text."
    echo " -H      : Redis IP."
    echo " -p      : Redis port."
    echo
}

function parse_options()
{

	case $1 in

		-h) usage
			exit 0
		;;
		-H) checkenv
	esac
}

if [ -z $1 ]; then
	echo "WARRING - Example : ./check_Redis_slowlog.sh -H 127.0.0.1 -p 6379 "
	exit 1;
fi

if [ $ARG1 == '-H' ] || [ $ARG1 == '-h' ]; then
	parse_options "$@"
fi

showloglen

if [ $LEN -eq 0 ]; then
	echo "OK - Redis $IP:$PORT is Normal"
else [ $LEN -gt 0 ];
	slowlogget
	#slowlogreset
	echo "WARRING - Redis $IP:$PORT SLOWLOG"
	echo "$result"
	exit 1
fi
