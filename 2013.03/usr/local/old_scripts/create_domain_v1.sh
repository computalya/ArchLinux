#!/bin/bash
# create_domain.sh
# Date		: 23. June 2011
# last updated	: 23. June 2011
# Description	: creates example.com on server (serenity/Arch Linux)
#		 
# Version	: 0.1 
# Changes	: 0.1
#			+ first working version
# Changes	: 0.1
#			+ added this title lines
# TO DO		:
#		  0.2
#		  	- add better parameter handling
#			- add chown -R ftp:ftp /srv/http/www/example.com/
#			- add pure-pw useradd example.com -u ftp -d /srv/http/www/example.com/
#			- add pure-pw mkdb
#			- add ./1.html mobile test page 

# check parameter
# if there is no parameter
if [ $# == 0 ] ; then
	echo
	echo "usage : create_domain.sh <example.com>"					# usage function
	echo
fi

# usage : ./create_domain.sh <example.com>
DOMAIN_NAME="${1}"
HTDOCS_DIR="/srv/http/www/${DOMAIN_NAME}/htdocs"
CONTENT_DIR="${HTDOCS_DIR}/content/"
INDEX="${CONTENT_DIR}/index.html"
VHOSTS_FILE="/etc/httpd/conf/extra/vhosts.d/${DOMAIN_NAME}.conf"

# create default directories
mkdir -p ${HTDOCS_DIR}/logs
mkdir -p ${CONTENT_DIR}logs
mkdir -p ${CONTENT_DIR}cgi-bin

# create default index.html
echo "<html>" &> "${INDEX}"
echo "<body>" &>> "${INDEX}"
echo "<h1>${DOMAIN_NAME}</h1>" &>> "${INDEX}"
echo "</body>" &>> "${INDEX}"
echo "</html>" &>> "${INDEX}"

# set permissions
chown ftp:ftp -R "${HTDOCS_DIR}"

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

exit 0
