#!/bin/bash
#
# Functions
tmp_file(){
	if [ -f "${TMP}" ] ; then
		rm -f "${TMP}"
	fi
	touch "${TMP}"
}

# main program
# check parameter
# if there is no parameter
if [ $# == 0 ] ; then
	echo "usage : "
	echo
	echo "${0} <file.txt>"					# usage function
	echo
	exit 1
fi

FILE="${1}"
TMP="/tmp/SMS.txt"
NEW="${1}.new"

#add 90 to the beginning of each line
#sed -e 's/^/90/g' IMO_20100124.txt &> abc.txt
sed 's/^/90/g' "${FILE}" &> "${TMP}"
mv "${TMP}" "${NEW}"

echo "${NEW} has been created" 
echo `cat ${NEW} | wc -l` "MSISDN numbers"

exit 0
