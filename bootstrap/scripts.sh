#/etc/bin/bash
#
# VARIABLES
# chech user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi

# main program
if [ ! -d /usr/local/scripts ] ; then
	mkdir /usr/local/scripts
	cp ../usr/local/scripts/* /usr/local/scripts
fi

# if path does not exist...
if ! [ `grep "/usr/local/scripts" /etc/paths &> /dev/null && echo $?` ] ; then
	echo "/usr/local/scripts" >> /etc/paths
fi
