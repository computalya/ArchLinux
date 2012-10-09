#/etc/bin/bash
# my rc.conf for ArchLinux VirtualBox
# 
# functions
# set trq keyboard
# 
# VARIABLES

locale_gen (){
	TR_ISO=`grep -v "#" "${LOC}"  | grep "tr_TR ISO-8859-9" &> /dev/null ; echo $?`
	TR_UTF8=`grep -v "#" "${LOC}" | grep "tr_TR.UTF-8 UTF-8" &> /dev/null ; echo $?`

	if [ "${TR_ISO}" == "0" ] ; then
		echo "tr_TR ISO-8859-9 exists already"
		else
			sed -e 's/^#tr_TR ISO-8859-9/tr_TR ISO-8859-9/g' "${LOC}" &> "${TMP_FILE}"
			mv "${TMP_FILE}" "${LOC}"
			echo "tr_TR ISO-8859-9 added to ${LOC}"
	fi

	if [ "${TR_UTF8}" == "0" ] ; then
		echo "tr_TR.UTF-8 UTF-8 exists already"
		else
			sed -e 's/^#tr_TR.UTF-8 UTF-8/tr_TR.UTF-8 UTF-8/g' "${LOC}" &> "${TMP_FILE}"
			mv "${TMP_FILE}" "${LOC}"
			echo "tr_TR.UTF-8 UTF-8 added to ${LOC}"
	fi


	locale-gen
}

consolefont (){
	# set consolefont in rc.conf
	# 
	CONSOLE=`grep -i "CONSOLEFONT" "${RC}" &> /dev/null ; echo $?`
	CONSOLE_VAL=`cat "${RC}" | grep -i "CONSOLEFONT" | grep -i "iso09.16" &> /dev/null ; echo $?`

	if [ "${CONSOLE}" == "0" ] ; then
		if [ "${CONSOLE_VAL}" == "0" ] ; then
			echo "${RC}: CONSOLEFONT=\"iso09.16\" exists already"
			else 
				echo "it exists already a CONSOLEFONT setting in ${RC}"
		fi
		else
			echo "CONSOLEFONT=\"iso09.16\"" >> "${RC}"
			echo "CONSOLEFONT=\"iso09.16\" added to ${RC}"
	
	fi
}
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
TMP_FILE="/tmp/rc_update.txt"
RC="/etc/rc.conf"
LOC="/etc/locale.gen"

# main program
locale_gen
locale
keymap
consolefont

exit 0

