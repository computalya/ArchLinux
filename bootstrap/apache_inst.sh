#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: apache_inst.sh
# Description   : 
# Date          : 12. Oct. 2012
# Last updated  : 12. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
# TO DO         :
# BUGS		: no known bugs at the moment
#
###############################################################################################
#functions
ip_banner(){
	# add ip_banner.sh to rc.local
	echo "bla"
}

# variables

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 2>&1
	echo "sudo ${0}"
	exit 1
fi

exit 0
