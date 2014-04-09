#!/bin/bash

# Script allow chck runing VirtualBox machines
# Authotr Oleg A. Deordiev

VBoxManage="/usr/bin/vboxmanage"
CheckBox=$1

if [ "$CheckBox" == "" ]
then
	echo "Need specify target virtual machine as argument"
	exit 3
fi


if [ ! -x $VBoxManage ]
then
	echo "UNKNOWN: Programm "$VBoxManage" not found"
	exit 3
fi


if $VBoxManage list runningvms | grep $CheckBox > /dev/null 2>&1
then
	echo "OK: Virtual Machine "$CheckBox" is runing"
	exit 0
else
	echo "CRITICAL: Virtual Machine "$CheckBox" not runing"
	exit 2
fi

