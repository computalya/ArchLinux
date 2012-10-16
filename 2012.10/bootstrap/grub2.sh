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
#		  + check root user 
#		  + mkinitcpio -p linux
#		  + display resolution to 1024x768
#		  + grub2 installation
# TO DO         : -NIL-
# BUGS		: no known bugs at the moment
#
###############################################################################################
# functions
bug_fix(){
	# currently there is an error message during boot of GRUB2
	# during first boot
	# error: file `/boot/grub/locale/en.mo.gz` not found.
	# during second boot
	# error: file `/boot/grub/locale/tr.mo.gz` not found.
	# to fix this, this fix is needed
	cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
	cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/tr.mo
}
# variables
TMP_FILE="/tmp/grub2.txt"

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

SUDO=`pacman -Q sudo &> /dev/null ; echo $?`
if [ "${SUDO}" != "0" ] ; then
	pacman -S grub-bios
fi

bug_fix
mkinitcpio -p linux

grub-mkconfig -o /boot/grub/grub.cfg
grub-install --recheck /dev/sda

echo "type your password for root user"
passwd

sed -e 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1024x768x32/g' /etc/default/grub &> "${TMP_FILE}"
mv "${TMP_FILE}" "/etc/default/grub"
echo
echo "exit ; umount /mnt ; reboot"

exit 0
