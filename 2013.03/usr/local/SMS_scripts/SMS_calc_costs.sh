#!/bin/bash
# cut -c 1-3
# 501 AVEA
# 505 AVEA
# 506 AVEA
# 507 AVEA
# 530 TURKCELL
# 531 TURKCELL
# 532 TURKCELL
# 533 TURKCELL
# 534 TURKCELL
# 535 TURKCELL
# 536 TURKCELL
# 537 TURKCELL
# 538 TURKCELL
# 539 TURKCELL
# 541 VODAFONE
# 542 VODAFONE
# 543 VODAFONE
# 544 VODAFONE
# 545 VODAFONE
# 546 VODAFONE
# 549 VODAFONE
# 552 AVEA
# 553 AVEA
# 554 AVEA
# 555 AVEA
# command to show only AREA codes
# cut -c 1-3 SMS_listesi_20090716.txt | sort -n | uniq
#
# this script calculates the cost of sending SMS for a list of subscribers
# File name of the subscribers list

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

# variables
COUNT="0"
SUM="0"
TOTAL_AVEA="0"
TOTAL_TCELL="0"
TOTAL_VFN="0"
FILE_SMS="$1"

# show
# area codes, and prices
# PRICE_VFN = P_VFN
# prices are in TL
# http://www.cardboardfish.com/products/largesmsaccounts/pricing_coverage.html#LetterT
P_VFN="0.075"
P_AVEA="0.075"
P_TCELL="0.15"

echo "list of area codes : "
AREA_CODES=`cut -c 1-3 "${FILE_SMS}" | sort -n | uniq`

#count variables
for i in `echo ${AREA_CODES}` ; do 
	COUNT=`expr $COUNT + 1`
	SUBSCRIBERS=`cut -c 1-3 ${FILE_SMS} | sort -n | grep $i | wc -l`
	echo -n "$i : $SUBSCRIBERS "
	# if AVEA
	if [ "${i}" -eq 501 ] || [ "${i}" -eq 505 ] || [ "${i}" -eq 506 ] || [ "${i}" -eq 507 ] || [ "${i}" -eq 552 ] || [ "${i}" -eq 553 ] || [ "${i}" -eq 554 ] || [ "${i}" -eq 555 ] ; then 
		echo "AVEA"
		SUM=`cat "${FILE_SMS}"  | cut -c 1-3 | grep "${i}" | wc -l`
		TOTAL_AVEA=`expr $TOTAL_AVEA + $SUM`
	fi

	# if TURKCELL
	if [ "${i}" -eq 530 ] || [ "${i}" -eq 531 ] || [ "${i}" -eq 532 ] || [ "${i}" -eq 533 ] || [ "${i}" -eq 534 ] || [ "${i}" -eq 535 ] || [ "${i}" -eq 536 ] || [ "${i}" -eq 537 ] || [ "${i}" -eq 538 ] || [ "${i}" -eq 539 ] ; then 
		echo "TURKCELL"
		SUM=`cat "${FILE_SMS}"  | cut -c 1-3 | grep "${i}" | wc -l`
		TOTAL_TCELL=`expr $TOTAL_TCELL + $SUM`
	fi

	# if VODAFONE
	if [ "${i}" -eq 541 ] || [ "${i}" -eq 542 ] || [ "${i}" -eq 543 ] || [ "${i}" -eq 544 ] || [ "${i}" -eq 545 ] || [ "${i}" -eq 546 ] || [ "${i}" -eq 547 ] || [ "${i}" -eq 548 ] || [ "${i}" -eq 549 ] ; then 
		echo "VODAFONE"
		SUM=`cat "${FILE_SMS}"  | cut -c 1-3 | grep "${i}" | wc -l`
		TOTAL_VFN=`expr $TOTAL_VFN + $SUM`
	fi
done
echo
echo "Total number of area codes : $COUNT"
echo
echo "Total AVEA subscribers : $TOTAL_AVEA SUBSCRIBERS : `echo $TOTAL_AVEA*$P_AVEA | bc` TL"
echo "Total TURKCELL subscribers : $TOTAL_TCELL SUBSCRIBERS : `echo $TOTAL_TCELL*$P_TCELL | bc` TL"
echo "Total VODAFONE subscribers : $TOTAL_VFN SUBSCRIBER : `echo $TOTAL_VFN*$P_VFN | bc` TL"
echo
echo "Total Costs : `echo $TOTAL_AVEA*$P_AVEA+$TOTAL_TCELL*$P_TCELL+$TOTAL_VFN*$P_VFN | bc` TL"
echo
exit 0

