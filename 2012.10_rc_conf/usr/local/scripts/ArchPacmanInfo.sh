#!/bin/bash
# ArchPacmanInfo.sh
# Date					: 07 Sep 2012
# last updated	: 07 Sep 2012
# Description		: check current pacman updates and show package name
#		 
# Version	: 1.0
# Changes	: 1.0
#		  1.0	+ first working version
#			+ added this title lines
#			+ usage function and parameters added
#			+ send an e-mail 
#			+ add total mount of pending updates on mail header
# TO DO		:
#			- NIL

# FUNCTIONS - START
usage (){
        echo "Usage:   ${PROGNAME} [-h|--help] | [-v|--version]"
        echo
        echo "  Parameter:"
        echo
        echo "    -h, --help            display this help and exit"
        echo "    -v, --version output  version information and exit"
        echo
				echo "to run this script weekly just create a link /etc/cron.weekly "
				echo "# ln -sf /usr/local/scripts/ArchPacmanInfo.sh /etc/cron.weekly"
				echo

        exit 0
}

sendmail(){
	mailx -s "SERENITY: pending pacman updates: ${NUMBER}" -r "gunduz.serenity+noreply@gmail.com" "${RCPT}" < "${TMP_FILE}"
}

# FUNCTIONS - END #

#**** do not change the lines below ****#

# setting variables
PROGNAME=`basename "${0}"`
VERSION="1.0"

TMP_FILE="/tmp/ArchPacmanInfo.tmp"
# settings to configure manually
#RCPT="atilla"
RCPT="gunduz.atilla+serenity@gmail.com"
#**** do not change the lines below ****#

# main program
#

# check for given parameters
for P in $@; do                                 # $@ = all parameters
  case $P in
        -h|-H|--[hH][eE][lL][pP])
                usage
        ;;
        -v|-V|--[vV][eE][rR][sS][iI][oO][nN])
                echo "Filename : ${PROGNAME}"
                echo "Version  : ${VERSION}"
                exit
        ;;
        *)
								usage
        ;;
  esac
done

# Get update list and removing headline
echo -n "creating package list : "
pacman -Syu -p --print-format "%n" | sed '/::/,/::/d' &> "${TMP_FILE}"
NUMBER=`cat ${TMP_FILE} | wc -l`
echo "done"


echo -n "sending e-mail : "
sendmail
echo "done"

exit 0
