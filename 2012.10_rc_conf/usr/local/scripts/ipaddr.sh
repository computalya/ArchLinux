#!/bin/bash
# Author        : Atilla Gündüz
# Script        : show ip
# Filename	: ipaddr.sh
# Description   : use ip command to show "only" the internal ip address
# Date          : 09. Oct. 2012
# Last updated  : 09. Oct. 2012
# Version       : 1.0
# Installation  : NIL
# Change Log    :
#                 1.0 	first version! 
#			usage function
#			help parameter
#			version parameter
#			backups a file or a directory
# TO DO         : NIL
# BUGS		: no known bugs at the moment
#
###################################################################################################
# functions
usage (){
	echo "Usage:   ${PROGNAME} [-h|--help] | [-v|--version]"
	echo
	echo "  Description : "
	echo "    This script just shows the internal ip address"
	echo "    Try ${PROGNAME} <filename>"
	echo
	echo "  Parameter:"
	echo
	echo "    -h, --help		display this help and exit"
	echo "    -v, --version	output version information and exit"
	echo
	exit 0
}

# main program
###############
VERSION="1.0"
PROGNAME=`basename $0`

for P in $@; do                                 # $@ = all parameters
  case $P in
        -h|-H|--[hH][eE][lL][pP])
                usage
        ;;
        -v|-V|--[vV][eE][rR][sS][iI][oO][nN])
                echo "Filename : ${PROGNAME}"
                echo "Version  : ${VERSION}"
		exit 0
	;;
        *)
                usage
        ;;
  esac
done

ip addr list eth0 | grep "inet" | cut -d' ' -f6 | cut -d/ -f1 | head -1	

exit 0
