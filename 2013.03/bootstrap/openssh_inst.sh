#!/bin/bash
# Author        : Atilla Gündüz
# Filename		: openssh_conf.sh
# Description   : OpenSSH configuration on a ArchLinux env.
# Date          : 18. Oct. 2012
# Last updated  : 13. Mar. 2013
# Version       : 1.2
# Installation  : 
# Change Log    :
#                 1.2 	first version! 
#		  			+ adapt systemd
#		  			+ install_openssh function
#                 1.0 	first version! 
#		  			+ check root user 
# TO DO         : -NIL-
#		  			- add paramater: remove installation
# BUGS		: no known bugs at the moment
#
###############################################################################################
# functions
install_openssh(){
	if [ `pacman -Q openssh &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S openssh --noconfirm

	fi
	# some keys needed at first time start
	if [ `ls /etc/ssh/*pub* &> /dev/null ; echo $?` == "2" ] ; then
		echo "no ssh keys found"
		ssh-keygen -A
		else
			echo "- error: some key exists already in /etc/ssh directory"
	fi

	systemctl start sshd.service
}

# variables
SSH_USERS="root computalya"		# this users will be configured for passwordless login
IP=`ip addr list enp0s5 | grep "inet" | cut -d' ' -f6 | cut -d/ -f1 | head -1`
FILE_PUBKEY="id_rsa.pub"

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

install_openssh

# check for public key
if [ -f "${HOME}/${FILE_PUBKEY}" ] ; then
	echo "it exists already a ${HOME}/${"FILE_PUBKEY"}"
	echo "if it is NOT the correct one CTRL+C"
	echo "if it is the correct one ENTER to continue..."
	read X

	else
		echo "- error: copy your public id -id_rsa.pub- to $HOME/.ssh"
		echo "         from the machine where the key is located"
		echo "         scp ~/.ssh/*.pub root@$IP:/root"
		echo "         and run again $0"
		echo 

		exit 1
fi

for i in `echo $SSH_USERS` ; do
	# find home directory of each user
	HOME_DIR=`cat /etc/passwd | grep "${i}" | cut -d":" -f6`
	# create .ssh
	if [ ! -d "${HOME_DIR}/.ssh" ] ; then
		su "${i}" -c "mkdir $HOME_DIR/.ssh"
		echo -e "\t+ $HOME_DIR/.ssh created"

		else
			echo "info -> $HOME_DIR/.ssh exist already"
	fi

	# create authorized_keys
	cat /root/$"{FILE_PUBKEY}" >> $HOME_DIR/.ssh/authorized_keys
	echo -e "\t+ authorized_keys created for $i"
done

rm /root/id_rsa.pub
echo -e "\t+ /root/${FILE_PUBKEY} removed"

# systemd services
systemctl restart sshd.service
systemctl enable sshd.service

exit 0
