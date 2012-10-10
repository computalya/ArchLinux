#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: openssh_conf.sh
# Description   : OpenSSH configuration on a ArchLinux env.
# Date          : 10. Oct. 2012
# Last updated  : 10. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
# TO DO         : -NIL-
#		  - check root user 
#		  - mkinitcpio -p linux
# BUGS		: no known bugs at the moment
#
###############################################################################################
# variables

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

exit 0
