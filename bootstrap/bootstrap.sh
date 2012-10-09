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
timezone(){
	if [ ! -e /etc/localtime ] ; then
		ln -s /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
		echo "/etc/localtime has been linked to /usr/share/zoneinfo/Europe/Istanbul"
		else
			echo "error: /etc/localtime exists already"
	fi
}
profile(){

	echo "${PROFILE}" >> "/etc/profile"
	echo "/etc/profile updated"
	
	cp -R ../etc/profile.d/computalya/ /etc/profile.d/computalya
	echo "/etc/profile.d/computalya created"

}
hostname(){

	if [ ! -f /etc/hostname ] ; then
		echo "${HOSTNAME}" >> /etc/hostname
		echo "hostname setted to: ${HOSTNAME}"
		else
			echo "error: /etc/hostname exists already"
	fi
}
scripts(){
	if [ ! -d /usr/local/scripts ] ; then
		mkdir /usr/local/scripts
		cp ../usr/local/scripts/* /usr/local/scripts
		echo "/usr/local/scripts created"
		else
			echo "error: /usr/local/scripts exists already"
	fi
}

# variables
HOSTNAME="ArchLinux_VB"
PROFILE="
# this has been added from ct_profile.sh
#
for PROFILE_SCRIPT in \$( ls /etc/profile.d/computalya/*.sh ); do
	. \$PROFILE_SCRIPT
done"

# main program
# chech user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

hostname
scripts
profile
timezone

echo "D E B U G"
exit 1

./create_users.sh
./rc_update.sh

exit 0
