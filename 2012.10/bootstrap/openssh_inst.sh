#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: openssh_conf.sh
# Description   : OpenSSH configuration on a ArchLinux env.
# Date          : 18. Oct. 2012
# Last updated  : 18. Oct. 2012
# Version       : 1.1
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
#		  + check root user 
# TO DO         : -NIL-
#		  * adapt systemd
#		  -* install_openssh function
#		  - add paramater: remove installation
# BUGS		: no known bugs at the moment
#
###############################################################################################
# functions
install_openssh(){
	# 
	if [ `pacman -Q openssh &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S openssh --noconfirm

		# some keys needed at first time start
		ssh-keygen -A
		systemctl start sshd.service
	fi
}

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

install_openssh

# check for public key
if [ -f "${HOME}/id_rsa.pub" ] ; then
	echo "it exists already a $HOME/id_rsa.pub"
	echo "if it is NOT the correct one CTRL+C"
	echo "if it is the correct one ENTER to continue..."
	read X

	else
		echo "copy your publich id -id_rsa.pub- to $HOME/.ssh"
		echo "from the machine where the key is located"
		# echo "scp ~/.ssh/*.pub root@192.168.1.26:/root"
		echo "scp ~/.ssh/*.pub root@$IP:/root"

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

	# create authorized_keys
#	su "${i}" -c "cat /root/id_rsa.pub >> $HOME_DIR/.ssh/authorized_keys"
	cat /root/id_rsa.pub >> $HOME_DIR/.ssh/authorized_keys
	echo "authorized_keys created for $i"
done

rm /root/id_rsa.pub
echo "/root/id_rsa.pub removed"

# systemd services
systemctl start sshd.service
systemctl enable sshd.service

exit 0
