#!/bin/bash
# check_ext_ip.sh
# Date		: 20. July 2006
# last updated	: 20. July 2006
# Description	: based on send_ipmail.sh 
#		  looks on the internet for the real IP address
# Version	: 0.4
# Changes	: 0.4
#			+ if links is not available show error message
# Changes	: 0.4
#		  	+ parameter added to force mail sending -f
#				+ check for external IP
#				+ send a mail			
# 		  0.2
#			+ code cleaning
#			+ usage function and parameters added
#			+ cronjob example added in --help
#			+ parameter -c added
#		  0.1
#		  	+ First running version
#			+ verbose mode. Inform with echo about each step
# TO DO		:


# FUNCTIONS - START
usage (){
	echo "Usage:   ${PROGNAME} [-h|--help] | [-v|--version] | [-c] | [-f]"
	echo
	echo "  Parameter:"
	echo
	echo "    -h, --help		display this help and exit"
	echo "    -v, --version	output 	version information and exit"
	echo "    -c,                   remove temporary files"
	echo "    -f,                   checks for current ip and send mail"
	echo
	echo "ex. cronjob: <user> is a valid linux user. Do not use root!"
	echo "-------------------------------------------------------------------------------"
	echo	"# run script every hour"
	echo	"0 * * * * <user> /usr/local/scripts/send_ipmail &> /dev/null"
	echo "-------------------------------------------------------------------------------"
	echo

	exit 0
}

cleanup(){

	# if $LOG_DIR existing, remove it
	echo -n "removing created temporary files of ${PROGNAME} : "
	if [ -d "${LOG_DIR}" ] ; then
		rm -rf "${LOG_DIR}"
	fi
	echo "done"
}

sendmail(){
	echo "sending mail"
	echo "Subject	: ${HOSTNAME}'s IP is : ${CURRENT_IP}"
	echo "To	: ${RCPT}"
#	mailx -s "${HOSTNAME}'s IP is : ${CURRENT_IP}" "${RCPT}" < "${LOG_FILE}"
}
update_log(){
# function to add status in a log file
	
	echo -e "${DATE}, ${HOSTNAME}, ${CURRENT_IP}" >> "${LOG_FILE}"
	#echo "THE CURRENT IP ADDRESS OF ${HOSTNAME} is: " > "${LOG_FILE}"
	#echo -e "\t\t${CURRENT_IP}" >> "${LOG_FILE}"
	#echo "${DATE}" >> "${LOG_FILE}"
	
	# restart everyDNS daemon
	/etc/rc.d/eDNS restart
}


current_ip(){
	# get current ip
	echo -n "checking on http://ipid.shat.net/iponly/ for the current ip address : "
	STAT=`lynx -dump -nolist http://ipid.shat.net/iponly/ &> ${FILE_TMP} ; echo $?`
	if [ "${STAT}" == "1" ] ; then
		echo "ERROR"
		echo "ERROR: http://ipid.shat.net/iponly/ is not reachable!!!"
		exit 1
	fi
	#CURRENT_IP=`lynx -dump -nolist http://ipid.shat.net/iponly/ | cut -f 4 -d " "  | head -n 1`
	CURRENT_IP=`cat "${FILE_TMP}" | cut -f 4 -d " " `
	echo "${CURRENT_IP}"
	
	echo -n "creating ${FILE_CURRENT_IP} : "
	echo "${CURRENT_IP}" > "${FILE_CURRENT_IP}"
	echo "done"
}
# FUNCTIONS - END #

# settings to configure manually
#RCPT="atilla"
#RCPT="gunduz.atilla@gmail.com"
#**** do not change the lines below ****#

# setting variables
PROGNAME=`basename "${0}"`
VERSION="0.4"

DATE=`date "+%Y%m%d %T"`
HOSTNAME=`hostname -f`
LOG_DIR="/tmp/check_ext_ip"
LOG_FILE="${LOG_DIR}/check_ext_ip.log"
FILE_CURRENT_IP="${LOG_DIR}/check_ext_ip.current"
FILE_LAST_IP="${LOG_DIR}/last_ip.txt"
FILE_TMP="${LOG_DIR}/check_ext_ip.tmp"

# main program
# check for given parameters
for P in $@; do					# $@ = all parameters
  case $P in
    	-h|-H|--[hH][eE][lL][pP])
		usage
      	;;
 	-v|-V|--[vV][eE][rR][sS][iI][oO][nN])
      		echo "Filename : ${PROGNAME}"
		echo "Version  : ${VERSION}"
		exit
      	;;
	-c)
		cleanup
		exit 0
	;;
	-f)
		current_ip
		update_log
		#sendmail
		exit 0
	;;
    	*)
		# wrong parameter
		usage
      	;;
  esac
done
# if $LOG_DIR not existing, create it
if [ ! -d "${LOG_DIR}" ] ; then
	mkdir "${LOG_DIR}"
fi


# if log file not existing create one 
# and start first time dns update
if [ ! -f "${LOG_FILE}" ] ; then
	echo -n "creating ${LOG_FILE} : "
	touch "${LOG_FILE}"
	echo "${DATE}, create a new log file" > "${LOG_FILE}"
	echo "done" 
	update_log
fi 

current_ip

# check whether there is no a last_ip.txt
if [ ! -f "${FILE_LAST_IP}" ] ; then
	echo -n "no ${FILE_LAST_IP} found! creating one : "
	cp -p "${FILE_CURRENT_IP}" "${FILE_LAST_IP}"
	echo "done"

#	echo -n "sending mail : "
	update_log
	#sendmail
	#mailx -s "${HOSTNAME}'s IP is : ${CURRENT_IP}" "${RCPT}" < "${LOG_FILE}"
#	echo "done"

	else
		echo -n "${FILE_LAST_IP} found, checking for differences : "
		RETURN=`diff "${FILE_CURRENT_IP}" "${FILE_LAST_IP}" &> /dev/null; echo $?`
		echo "done"
		if [ "${RETURN}" != "0" ] ; then
#			echo -n "sending mail : "
			update_log
			#sendmail
			#mailx -s "${HOSTNAME}'s IP is : ${CURRENT_IP}" "${RCPT}" < "${LOG_FILE}"
#			echo "done"
			
			echo -n "creating new ${FILE_LAST_IP} : "
			cp -p "${FILE_CURRENT_IP}" "${FILE_LAST_IP}"
			echo "done"
			else
				echo "IP is not changed"	
		fi
fi

exit 0




