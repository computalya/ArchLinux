#/etc/bin/bash
# set hostname
# 
# VARIABLES
if [ ! -f /etc/hostname ] ; then
	echo "ArchLinux_VB" >> /etc/hostname
	echo "hostname setted to: ArchLinux_VB"
	else
		echo "error: /etc/hostname exists already"
fi

exit 0
