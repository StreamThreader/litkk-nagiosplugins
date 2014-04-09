#!/bin/bash

# Script check NTP Stratum

TARGETHOST=$1
WARNINVAL=$2
CRITICVAL=$3
STRATUM=""
STAT=""

if [ -z "$TARGETHOST" ]
then
	TARGETHOST="127.0.0.1"
fi

if [ -z "$WARNINVAL" ]
then
	WARNINVAL="6"
fi

if [ -z "CRITICVAL" ]
then
	CRITICVAL="10"
fi

echolot () {
	echo "$STAT NTP Stratum is: $STRATUM"
}

if ! ntpdc -nc sysinfo $TARGETHOST 2> /dev/null | grep stratum > /dev/null 2>&1
then
	STAT="Critical"
	STRATUM="not determined"
	echolot
	exit 2
fi

STRATUM="$(ntpdc -nc sysinfo $TARGETHOST | grep stratum | awk '{printf $2}' | xargs echo)"

if [ "$STRATUM" -lt "$WARNINVAL" ] || [ "$STRATUM" -eq "$WARNINVAL" ]
then
	STAT="OK"
	echolot
	exit 0
fi

if [ "$STRATUM" -gt "$WARNINVAL" ] && [ "$STRATUM" -lt "$CRITICVAL" ]
then
	STAT="Warning"
	echolot
	exit 1
fi

if [ "$STRATUM" -gt "$WARNINVAL" ] && [ "$STRATUM" -gt "$CRITICVAL" ]
then
	STAT="Critical"
	echolot
	exit 2
fi

