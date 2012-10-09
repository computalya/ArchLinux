#/etc/bin/bash
# set trq keyboard
# 
# VARIABLES
CHECK_KEYMAP=`grep -i "KEYMAP" /etc/rc.conf &> /dev/null ; echo $?`
CHECK_TRQ=`cat /etc/rc.conf | grep -i "KEYMAP" | grep -i "trq" &> /dev/null ; echo $?`

if [ "${CHECK_KEYMAP}" == "0" ] && [ "${CHECK_TRQ}" == "0" ] ; then
	echo "/etc/rc.conf: KEYMAP=\"trq\" exists already"
	else 
		echo "KEYMAP=\"trq\"" >> rc.conf
fi
