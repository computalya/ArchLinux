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

for i in `echo $SSH_USERS` ; do
	# find home directory of each user
	HOME_DIR=`cat /etc/passwd | grep "${i}" | cut -d":" -f6`
	su "${i}" -c "echo $HOME_DIR"
done

exit 0
