#!/bin/bash
# Author        : Atilla Gündüz
# Script        : bootstrap
# Filename	: bootstrap.sh
# Description   : 
# Date          : 09. Oct. 2012
# Last updated  : 10. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
#		  + pacman: system update, remove unnecessary packages and install needed packages
#		  + vimrc: vim color syntax on
#		  + check root user 
#		  + add support for remarks in packages.* files
# TO DO         :
# BUGS		: no known bugs at the moment
#
###############################################################################################
#functions
ip_banner(){
	# add ip_banner.sh to rc.local
	cp ../etc/rc.d/ip_banner.sh /etc/rc.d
	echo "/etc/rc.d/ip_banner.sh" >>  /etc/rc.local
	echo "ip_banner.sh added to /etc/rc.local"
}
vimrc(){
	VIMRC=`cat /etc/vimrc | grep "syntax on" &> /dev/null ; echo $?`
	echo $VIMRC
	if [ ${VIMRC} != 0 ] ; then
		echo "syntax on" >> /etc/vimrc
		echo "syntax on added to /etc/vimrc"
		else
			echo "error: syntax on exists already in /etc/vimrc"
	fi
}

pacman_updates(){
	pacman -Syu

	for i in `cat packages.install | sed 's/ *[#;].*$//g' | sed 's/^ *//' | sed '/^$/d'` ; do
		if [ ! `pacman -Q "${i}" &> /dev/null ; echo $?` == 0 ] ; then
			pacman -S "${i}" --noconfirm
		fi
	done

	for i in `cat packages.uninstall | sed 's/ *[#;].*$//g' | sed 's/^ *//' | sed '/^$/d'` ; do
		if [ `pacman -Q "${i}" &> /dev/null ; echo $?` == 0 ] ; then
			pacman -R "${i}" --noconfirm
		fi
	done
}
create_user(){
	CHECK_USERNAME=`cat /etc/passwd | cut -d":" -f1 | grep "${USERNAME}" &> /dev/null ; echo $?`
	SUDO=`pacman -Q sudo &> /dev/null ; echo $?`
	if [ "${CHECK_USERNAME}" != "0" ] ; then
        	useradd -m -g users -G locate,storage,wheel -s /bin/bash "${USERNAME}"
	        echo "type a password for user : ${USERNAME}"
		passwd "${USERNAME}"
		else
			echo "user ${USERNAME} exists already. nothing to do"
	fi

	# add user to sudoer
	# check whether sudo is installed
	if [ "${SUDO}" != "0" ] ; then
		echo "sudo is not installed. do pacman -S sudo"
		else
			echo "${USERNAME} ALL=(ALL) ALL" >> /etc/sudoers
			echo "sudoers udpated"
	fi
}
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
USERNAME="computalya"
PROFILE="
# this has been added from ct_profile.sh
#
for PROFILE_SCRIPT in \$( ls /etc/profile.d/computalya/*.sh ); do
	. \$PROFILE_SCRIPT
done"

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 2>&1
	echo "sudo ${0}"
	exit 1
fi

echo "ENTER for pacman -Syu"
read x
pacman_updates

hostname
scripts
profile
vimrc
timezone
ip_banner
create_user

./rc_update.sh
echo "to start grub installation ENTER"
read x
./grub2.sh

exit 0
