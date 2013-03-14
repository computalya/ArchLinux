#!/bin/bash
# DONE:
#	+ filenames with dateformat
# 	+ adapt quality of pics
#	+ send a mail to gmail?
#	+ check and create directory $TARGETDIR
# TODO:
#	- check and create directory $TARGETDIR/$DATEDIR
#	- this script should be run from port online script!

TIME=`date +%G%m%d%H%M`
DATE=`date +%G%m%d`
FILENAME="PICTURE.${TIME}.jpg"
TARGETDIR="/tmp/VNC_PICTURES"			# main directory, where all pictures are saved
PICDIR="${TARGETDIR}/${DATE}"				# for each day create a unique directory
MAIL_FROM="some_gmail_address@gmail.com"
MAIL_SUBJECT="${FILENAME}"

# check whether $TARGETDIR exists
echo -n "checking for ${TARGETDIR} -> "
	if [ ! -d "${TARGETDIR}" ] ; then
	echo -n "creating $TARGETDIR -> "
	mkdir "${TARGETDIR}"
fi
echo "ok"

# check whether $PICDIR exists
echo -n "checking for ${PICDIR} -> "
	if [ ! -d "${PICDIR}" ] ; then
	echo -n "creating $PICDIR -> "
	mkdir "${PICDIR}"
fi
echo "ok"

cd "${PICDIR}"
vncsnapshot -quiet -passwd /home/username/.vnc/passwd.txt -quality 50 -vncQuality 9 192.168.1.9 "${FILENAME}" &> /dev/null
#echo "$MAIL_SUBJECT" | nail -r "${MAIL_FROM}" -s "${MAIL_SUBJECT}" -a "${FILENAME}" "to_addr@gmail.com"
exit 0
