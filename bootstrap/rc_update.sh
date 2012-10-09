#/etc/bin/bash
# my rc.conf for ArchLinux VirtualBox
# 
# functions
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
#RC="/etc/rc.conf"
RC="rc.conf"

# main program
locale

exit 0

