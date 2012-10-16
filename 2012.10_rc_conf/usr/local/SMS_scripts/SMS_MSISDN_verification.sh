#!/bin/bash
# TO DO		:
#			- 10 haneli olmayan numaralari goster
#			- 10 haneliden fazla olan numaralari goster
#			- rapor goster: hangi numaralar ciftti? belki bir log dosyasina at
#

# FUNCTIONS - START
tmp_file(){
	if [ -f "${TMP}" ] ; then
		rm -f "${TMP}"
	fi
	touch "${TMP}"
}

rm_blanks_beginning(){
# remove blanks and tabs at the beginning of each line
	sed 's/^[ \t]*//' "${FILE}" &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

rm_blanks_end(){
# remove blanks and tabs at the end of each line
	sed 's/[ \t]*$//' "${NEW}" &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

rm_blanks_between(){
# remove blanks and tabs from each line
	sed 's/[\t ]*//g' "${NEW}" &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

rm_zero_beginning(){
# remove 0 from the beginning of each line
#	sed 's/^0//gp' "${NEW}" &> "${TMP}"
	sed 's/^[0]*//g' "${NEW}" &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

rm_all_except_numbers(){
# remove all charachters from a line except numbers
# ex. 0542/396-26-16 -> 5423962616
	sed 's/[^0-9.]*//g' "${NEW}" &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

rm_blank_lines(){
# remove all blank lines
	sed '/^$/d' "${NEW}" | grep -v '^$' &> "${TMP}"
	mv "${TMP}" "${NEW}"
}

sort_lines(){
# sort all lines
	cat "${NEW}" | sort -n | uniq &> "${TMP}"
	mv "${TMP}" "${NEW}"
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

tmp_file
rm_blanks_beginning
rm_blanks_end
rm_blanks_between
rm_zero_beginning
rm_all_except_numbers
rm_blank_lines
sort_lines 							# and remove duplicates

echo "${NEW} has been created" 
echo `cat ${NEW} | wc -l` "MSISDN numbers"


exit 0
