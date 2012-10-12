#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: ipaddr.sh
# Description   : show current ip address at the console login screen
# Date          : 12 Oct. 2012
# Last updated  : 12 Oct. 2012
# Version       : 1.0
# Installation  : NIL
# 		copy this script to /etc/rc.d/ip_banner.sh
#
#		echo "/etc/rc.d/ip_banner.sh" >>  /etc/rc.local
# Change Log    :
# TO DO         : NIL
# BUGS		: no known bugs at the moment
#
###################################################################################################
ISSUE="/etc/issue"
IP=`ip addr list eth0 | grep "inet" | cut -d' ' -f6 | cut -d/ -f1 | head -1`	
TMP="/tmp/ip_banner.tmp"

CHECK=`cat $ISSUE | grep "IP Address :" &> /dev/null ; echo $?` 
if [ $CHECK != "0" ] ; then
	echo "IP Address : $IP" &>> $ISSUE
	else
		cat $ISSUE | grep -v "IP Address" &> $TMP
		echo "IP Address : $IP" &>> $TMP
		mv $TMP $ISSUE
fi

exit 0
