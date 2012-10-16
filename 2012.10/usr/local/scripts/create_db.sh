#!/bin/bash
# create_db_v1.sh
# Date		: 04. July 2011
# last updated	: 04. July 2011
# Description	: creates mysql db and user on localhost 
#		 
# Version	: 0.1 
#			+ first running versiong
# Changes	: 0.1
# TO DO		:
#			- no need for command line parameter!
#			- ask for DB USERNAME. currently db username and pass are same
#			- add phpmyadmin only for this created user!
#			- show a mail output with information (db username/pass etc) ask to send it

# FUNCTIONS - START
usage (){
        echo "Usage:   ${PROGNAME} <example_com_db1> [-h|--help] | [-v|--version]"
        echo
        echo "  Parameter:"
        echo
        echo "    -h, --help            display this help and exit"
        echo "    -v, --version output  version information and exit"
        echo

        exit 0
}

create_db (){
	echo -e "type MYSQL password for root user : "
	read MYSQL_PW

	mysql -u root -p"${MYSQL_PW}" -e "CREATE USER '${DB_NAME}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
	mysql -u root -p"${MYSQL_PW}" -e "GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON *.* TO '"${DB_NAME}"'@'localhost' IDENTIFIED BY '"${DB_PASS}"' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"

	mysqladmin -u root -p"${MYSQL_PW}" create "${DB_NAME}"
	mysql -u root -p"${MYSQL_PW}" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '${DB_NAME}'@'localhost';"

	echo " DB USERNAME : ${DB_NAME}" 
	echo " DB NAME     : ${DB_NAME}"
	echo " DB PASS     : ${DB_PASS}"
}

# FUNCTIONS - END #

#**** do not change the lines below ****#

# setting variables
PROGNAME=`basename "${0}"`
VERSION="0.1"

DOMAIN_NAME="${1}"

# main program
#

# check parameter
# if there is no parameter
if [ $# == 0 ] ; then
	usage					# usage function
fi

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
                echo "create db $DOMAIN_NAME"
		echo -n "type a database name : "
		read DB_NAME
		echo -n "type password : "
		read DB_PASS
		create_db			
        ;;
  esac
done

exit 0
