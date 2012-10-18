#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: set_ip.sh
# Description   : set static ip for serenity
# Date          : 18. Oct. 2012
# Last updated  : 18. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
#		  	+ check root user 
#		  	+ check for netcfg package
#		  	+ disable dhcpcd service
#		  	+ set static ip
# TO DO         : -NIL-
# BUGS		: no known bugs at the moment
#
###############################################################################################
# functions

# variables
SETTINGS="CONNECTION='ethernet'\n
DESCRIPTION='A basic static ethernet connection using iproute\n
INTERFACE='eth0'\n
IP='static'\n
ADDR='192.168.2.9'\n
GATEWAY='192.168.2.1'\n
DNS=('192.168.2.1')"

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

if [ `pacman -Q netcfg &> /dev/null ; echo $?` != "0" ] ; then
	pacman -S netcfg --noconfirm
fi

systemctl disable dhcpcd@eth0.service

echo -e $SETTINGS > /etc/network.d/ethernet-static
netcfg ethernet-static
systemctl enable netcfg@ethernet-static.service

exit 0
