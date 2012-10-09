#/etc/bin/bash
# my rc.conf for ArchLinux VirtualBox
# 
# functions
# set trq keyboard
# 
# VARIABLES
keymap(){
	KEYMAP=`grep -i "KEYMAP" "${RC}" &> /dev/null ; echo $?`
	KEYMAP_VAL=`cat "${RC}" | grep -i "KEYMAP" | grep -i "trq" &> /dev/null ; echo $?`

	if [ "${KEYMAP}" == "0" ] ; then
		if [ "${KEYMAP_VAL}" == "0" ] ; then
			echo "${RC}: KEYMAP=\"trq\" exists already"
			else 
				echo "it exists already a KEYMAP setting in ${RC}"
		fi
		else
			echo "KEYMAP=\"trq\"" >> "${RC}"
			echo "KEYMAP=\"trq\" added to ${RC}"
	fi
}

locale (){
	LOCALE=`grep -i "LOCALE" "${RC}" &> /dev/null ; echo $?`
	LOCALE_VAL=`cat "${RC}" | grep -i "LOCALE" | grep -i "tr_TR.UTF8" &> /dev/null ; echo $?`

	if [ "${LOCALE}" == "0" ] ; then
		if [ "${LOCALE_VAL}" == "0" ] ; then
			echo "${RC}: LOCALE=\"tr_TR.UTF8\" exists already"
			else 
				echo "it exists already a LOCALE setting in ${RC}"
		fi
		else
			echo "LOCALE=\"tr_TR.UTF8\"" >> "${RC}"
			echo "LOCALE=\"tr_TR.UTF8\" added to ${RC}" 

	fi
}
# variables
RC="/etc/rc.conf"

# main program
keymap
locale

exit 0

