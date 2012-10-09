#!/bin/bash
# Author        : Atilla Gündüz
# Script        : bootstrap
# Filename	: bootstrap_v1_0.sh
# Description   : 
# Date          : 09. Oct. 2012
# Last updated  : 09. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
# TO DO         :
#		  - check root user 
# BUGS		: no known bugs at the moment
#
###############################################################################################
#functions
hostname(){

	if [ ! -f /etc/hostname ] ; then
		echo "${HOSTNAME}" >> /etc/hostname
		echo "hostname setted to: ${HOSTNAME}"
		else
			echo "error: /etc/hostname exists already"
			exit 1
	fi
}

# variables
HOSTNAME="ArchLinux_VB"

# main program
# chech user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

hostname
echo "D E B U G"
exit 1

./timezone.sh
./ct_profile.sh
./scripts.sh
./create_users.sh
./rc_update.sh

exit 0
