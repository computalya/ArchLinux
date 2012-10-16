#!/bin/bash
# Author        : Atilla Gündüz
# Script        : backup
# Filename	: backup_v1_0.sh
# Description   : script to do a quick backup of a file or directory
# Date          : 21. Mar. 2006
# Last updated  : 21. Mar. 2006
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
#			usage function
#			help parameter
#			version parameter
#			backups a file or a directory
# TO DO         :
# BUGS		: no known bugs at the moment
#
###################################################################################################
# functions
usage (){
	echo "Usage:   ${PROGNAME} <filename> [-h|--help] | [-v|--version]"
	echo
	echo "  Description : "
	echo "    This script does easily a backup of a file or directory"
	echo "    Just try ${PROGNAME} <filename>"
	echo
	echo "  Parameter:"
	echo
	echo "    -h, --help		display this help and exit"
	echo "    -v, --version	output version information and exit"
	echo
	exit 0
}

file_backup (){
	echo "Dateiname : ${P}"
	FILENAME="${P}.backup.${TIME}"
	cp -p "${P}" "${FILENAME}"
	echo "Sicherung ${FILENAME} erstellt"
}

dir_backup (){
	FILENAME=`basename ${P}`
	PATHNAME=`cd ${P} ; cd .. ; pwd`

	DIRNAME="${PATHNAME}/${FILENAME}.backup.${TIME}"

	cp -pr "${P}" "${DIRNAME}"
	echo
	echo "${DIRNAME} erstellt"
}

# main program
###############
VERSION="1.0"
PROGNAME=`basename $0`
TIME=`date +%G%m%d%H%M`

# check parameter
# if there is no parameter
if [ $# == 0 ] ; then
	usage					# usage function
fi

for P in $@; do                                 # $@ = all parameters
  case $P in
        -h|-H|--[hH][eE][lL][pP])
                usage
        ;;
        -v|-V|--[vV][eE][rR][sS][iI][oO][nN])
                echo "Filename : ${PROGNAME}"
                echo "Version  : ${VERSION}"
	;;
        *)
# 		is a directory or a file	
		if [ ! -d "${P}" ] && [ ! -f "${P}" ] ; then
			echo "invalid option : ${P}"
			exit 1
		fi
		if [ -d "${P}" ] ; then
			dir_backup
		fi
		if [ -f "${P}" ] ; then
			file_backup
		fi
        ;;
  esac
done

exit 0
