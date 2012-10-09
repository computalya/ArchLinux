#/etc/bin/bash
# set consolefont in rc.conf
# 
# VARIABLES
CHECK_CONSOLE=`grep -i "CONSOLEFONT" /etc/rc.conf &> /dev/null ; echo $?`
CHECK_ISO=`cat /etc/rc.conf | grep -i "CONSOLEFONT" | grep -i "iso09.16" &> /dev/null ; echo $?`

if [ "${CHECK_CONSOLE}" == "0" ] ; then
	if [ "${CHECK_ISO}" == "0" ] ; then
		echo "/etc/rc.conf: CONSOLEFONT=\"iso09.16\" exists already"
		exit 1
		else 
			echo "it exists already a CONSOLEFONT setting in /etc/rc.conf"
	fi
	else
		echo "CONSOLEFONT=\"iso09.16\"" >> /etc/rc.conf
	
fi

exit 0
if [ "${CHECK_CONSOLE}" == "0" ] && [ "${CHECK_ISO}" == "0" ] ; then
	echo "/etc/rc.conf: CONSOLEFONT=\"iso09.16\" exists already"
	else 
		echo "CONSOLEFONT=\"iso09.16\"" >> /etc/rc.conf
fi
