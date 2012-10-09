#!/bin/bash
# Author        : Atilla Gündüz
# Script        : grub2
# Filename	: grub2.sh
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

# main program
# chech user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

mkinitcpio -p linux
pacman -S grub-bios
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --recheck /dev/sda

echo "type your password for root user"
passwd

echo
echo "exit ; umount /mnt ; reboot"

exit 0
