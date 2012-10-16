#!/bin/bash
# Author        : Atilla Gündüz
# Script        : Sending SMS via HTTPSMS protocol
# Filename	: SMS_send_v0_01.sh
# Description   : Sending SMS via HTTPSMS protocol
# Date          : 13. Jul. 2009
# Last updated  : 13. Jul. 2009
# Version       : 0.1
# Installation  : 
# Change Log    :
#                 0.1 	first running version! 
#			sending SMS via variables in code is possible
# TO DO         :
#			usage function
#			help parameter
#			version parameter
# BUGS		: no known bugs at the moment
#
###################################################################################################
# functions

# variables
VERSION="0.1"
PROGNAME=`basename $0`
TIME=`date +%G%m%d%H%M`

SERVER="https://sms2.cardboardfish.com:9444/HTTPSMS?"
USERNAME="put_username_here"
PASSWORD="put_pw_here"

# test SMS 
SOURCE="linux"
DESTINATION="905300000000"
MESSAGE="just a test from ArchLinux"

LOGFILE="${TIME}_${DESTINATION}.txt"
# main program
###############

# send sms and store status in TXT file
wget "${SERVER}S=H&UN=${USERNAME}&P=${PASSWORD}&DA=${DESTINATION}&SA=${SOURCE}&M=${MESSAGE}" -O "${LOGFILE}"

exit 0
