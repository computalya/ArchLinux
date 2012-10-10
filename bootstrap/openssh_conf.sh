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
SSH_USERS="root computalya"		# this users will be configured for passwordless login

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

# check for public key
if [ -f "${HOME}/.ssh/id_rsa.pub" ] ; then
	echo "it exists alread an $HOME/.ssh/id_rsa.pub"
	echo "if it is NOT the correct one, save it and copy the correct one with this command"
	exit 1
	else
		echo "moment"
		exit 1
fi

for i in `echo $SSH_USERS` ; do
	# find home directory of each user
	HOME_DIR=`cat /etc/passwd | grep "${i}" | cut -d":" -f6`
	# create .ssh
	if [ ! -d "${HOME_DIR}/.ssh" ] ; then
		su "${i}" -c "mkdir $HOME_DIR/.ssh"
		echo "$HOME_DIR created"
		else
			echo "info -> $HOME_DIR/.ssh exist already"
	fi
done

exit 0
