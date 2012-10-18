#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: set_dhcp.sh
# Description   : set dhcp for serenity
# Date          : 18. Oct. 2012
# Last updated  : 18. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
#		  	+ check root user 
#		  	+ disable netcfg service
#		  	+ start dhcp
# TO DO         : -NIL-
# BUGS		: no known bugs at the moment
#
###############################################################################################
# functions

# variables

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

systemctl disable netcfg@ethernet-static.service
systemctl enable dhcpcd@eth0.service


exit 0
