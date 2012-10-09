#/etc/bin/bash
# set time zone
# 
# VARIABLES
if [ ! -e /etc/localtime ] ; then
	ln -s /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
	echo "/etc/localtime has been linked to /usr/share/zoneinfo/Europe/Istanbul"
	else
		echo "error: /etc/localtime exists already"
fi

exit 0
