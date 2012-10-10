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
IP=`ip addr list eth0 | grep "inet" | cut -d' ' -f6 | cut -d/ -f1 | head -1`

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

# check for public key
if [ -f "${HOME}/id_rsa.pub" ] ; then
	echo "it exists already a $HOME/id_rsa.pub"
	echo "if it is NOT the correct one CTRL+C"
	echo "if it is the correct one ENTER to continue..."
	read X
	echo "ok"
	exit 1
	else
		echo "copy your publich id -id_rsa.pub- to $HOME/.ssh"
		echo "from the machine where the key is located"
#		echo "cat ~/.ssh/*.pub | ssh root@$IP 'cat>>.ssh/authorized_keys'"
		echo "scp ~/.ssh/*.pub root@192.168.1.26:/root"
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
