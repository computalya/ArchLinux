#!/bin/bash
# create_domain_v2.sh
# Date		: 23. June 2011
# last updated	: 23. June 2011
# Description	: creates example.com on server (serenity/Arch Linux)
#		 
# Version	: 0.2 
# Changes	: 0.1
#			+ first working version
#			+ added this title lines
#		  0.2
#			+ usage function and parameters added
#			+ changed all code to functions
#			+ add pure-pw useradd example.com -u ftp -d /srv/http/www/example.com/
#			+ add pure-pw mkdb
# TO DO		:
#			- add no-www .htaccess file
# 			- retype ftp-pass and check pass identity
#			- add ./1.html mobile test page 
#			- add script to dig @8.8.8.8 example.com +short and external ip to send automated mail to inform me
#			- parameter for installation -c --create
#			- remove domain/ftp/files with -r parameteter
#			- send automatically created e-mail with http link and ftp login details

# FUNCTIONS - START
usage (){
        echo "Usage:   ${PROGNAME} <example.com> [-h|--help] | [-v|--version]"
        echo
        echo "  Parameter:"
        echo
        echo "    -h, --help            display this help and exit"
        echo "    -v, --version output  version information and exit"
        echo

        exit 0
}

create_dir (){
	# create default directories
	mkdir -p ${HTDOCS_DIR}/logs
	mkdir -p ${CONTENT_DIR}logs
	mkdir -p ${CONTENT_DIR}cgi-bin
}

create_index (){
	# create default index.html
	echo "<html>" &> "${INDEX}"
	echo "<body>" &>> "${INDEX}"
	echo "<h1>${DOMAIN_NAME}</h1>" &>> "${INDEX}"
	echo "</body>" &>> "${INDEX}"
	echo "</html>" &>> "${INDEX}"
}

set_permissions (){
	# set directory permissions
	chown -R ftp:ftp "${HTDOCS_DIR}"

}

create_vhosts (){
	# create vhosts for apache
	# create vhosts.conf for apache
	echo "<VirtualHost *:80>" &> "${VHOSTS_FILE}"
	echo -e "\tServerAdmin admin@computalya.com" &>> "${VHOSTS_FILE}"
	echo -e "\tServerName www.${DOMAIN_NAME}" &>> "${VHOSTS_FILE}"
	echo -e "\tServerAlias ${DOMAIN_NAME} www.${DOMAIN_NAME}" &>> "${VHOSTS_FILE}"
	echo -e "\tRewriteEngine On" &>> "${VHOSTS_FILE}"
	echo -e "\tRewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)" &>> "${VHOSTS_FILE}"
	echo -e "\tRewriteRule .* -[F]" &>> "${VHOSTS_FILE}"
	echo -e "\tRewriteRule ^(${CONTENT_DIR}.*) ${HTDOCS_DIR}\$1" &>> "${VHOSTS_FILE}"
	echo -e "\tDocumentRoot ${CONTENT_DIR}" &>> "${VHOSTS_FILE}"
	echo -e "\tServerPath ${CONTENT_DIR}" &>> "${VHOSTS_FILE}"
	echo -e "\tErrorLog ${HTDOCS_DIR}/logs/error.log" &>> "${VHOSTS_FILE}"
	echo -e "\tCustomLog ${HTDOCS_DIR}/logs/access.log combined" &>> "${VHOSTS_FILE}"
	echo -e "\tScriptAlias /cgi-bin/ ${CONTENT_DIR}cgi-bin/" &>> "${VHOSTS_FILE}"
	echo "" &>> "${VHOSTS_FILE}"
	echo -e "\t<Directory ${CONTENT_DIR}>" &>> "${VHOSTS_FILE}"
	echo -e "\t\tAllowOverride   All" &>> "${VHOSTS_FILE}"
	echo -e "\t\tOrder           allow,deny" &>> "${VHOSTS_FILE}"
	echo -e "\t\tAllow           from all" &>> "${VHOSTS_FILE}"
	echo -e "\t</Directory>" &>> "${VHOSTS_FILE}"
	echo "" &>> "${VHOSTS_FILE}"
	echo -e "\t<Directory ${CONTENT_DIR}cgi-bin/>" &>> "${VHOSTS_FILE}"
	echo -e "\t\tAllowOverride   None" &>> "${VHOSTS_FILE}"
	echo -e "\t\tOptions         ExecCGI" &>> "${VHOSTS_FILE}"
	echo -e "\t\tOrder           allow,deny" &>> "${VHOSTS_FILE}"
	echo -e "\t\tAllow           from all" &>> "${VHOSTS_FILE}"
	echo -e "\t</Directory>" &>> "${VHOSTS_FILE}"
	echo -e "</VirtualHost>" &>> "${VHOSTS_FILE}"
}
create_ftp_login (){
	# (echo cigdem; echo cigdem) | pure-pw useradd cigdem.com -u ftp -d /srv/http/www/cigdem.com/
	(echo ${FTP_PASS};echo ${FTP_PASS}) | pure-pw useradd ${DOMAIN_NAME} -u ftp -d ${HTDOCS_DIR}
	pure-pw mkdb
}

# FUNCTIONS - END #

#**** do not change the lines below ****#

# setting variables
PROGNAME=`basename "${0}"`
VERSION="0.2"

DOMAIN_NAME="${1}"
HTDOCS_DIR="/srv/http/www/${DOMAIN_NAME}/htdocs"
CONTENT_DIR="${HTDOCS_DIR}/content/"
INDEX="${CONTENT_DIR}/index.html"
VHOSTS_FILE="/etc/httpd/conf/extra/vhosts.d/${DOMAIN_NAME}.conf"

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
                echo "create domain $DOMAIN_NAME"
		echo -n "type a FTP password : "
		read FTP_PASS
		create_dir			# create default directories
		create_index			# create default index.html file
		set_permissions			# set directory permissions
		create_vhosts			# create vhosts for apache
		/etc/rc.d/httpd reload
		create_ftp_login
        ;;
  esac
done

exit 0
