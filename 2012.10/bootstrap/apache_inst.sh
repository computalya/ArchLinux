#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: apache_inst.sh
# Description   : 
# Date          : 12. Oct. 2012
# Last updated  : 12. Oct. 2012
# Version       : 1.0
# Installation  : 
# Change Log    :
#                 1.0 	first version! 
# TO DO         :
# BUGS		: no known bugs at the moment
#
###############################################################################################
#functions
vhost(){
	# update httpd.conf
	HTTPD_CONF="/etc/httpd/conf/httpd.conf"
	EXTRA_CONF="/etc/httpd/conf/extra/httpd-vhosts.conf"
	DEFAULT_HOST="NameVirtualHost *:80\n\n
<VirtualHost *:80>
\tDocumentRoot /srv/http/
\tServerName localhost
\tServerAlias localhost
</VirtualHost>\n
Include conf/extra/vhosts.d/*.conf"

	VHOST_EXAMPLE_1="
<VirtualHost *:80>
\tDocumentRoot /srv/http/vhost1
\tServerName vhost1.localhost
\tServerAlias www.vhost1.localhost
</VirtualHost>"

	VHOST_EXAMPLE_2="
<VirtualHost *:80>
\tDocumentRoot /srv/http/vhost2
\tServerName vhost2.localhost
\tServerAlias www.vhost2.localhost
</VirtualHost>"

HTML1="<!DOCTYPE html>
<html lang="tr">
    <head>
        <meta charset="utf-8">
        <title>Merhaba dünya</title>
    </head>
    <body>
        <h1>Merhaba dünya</h1>
        <p>
            vhost1.localhost çalışıyor
        </p>
    </body>
</html>"
	
HTML2="<!DOCTYPE html>
<html lang="tr">
    <head>
        <meta charset="utf-8">
        <title>Merhaba dünya</title>
    </head>
    <body>
        <h1>Merhaba dünya</h1>
        <p>
            vhost2.localhost çalışıyor
        </p>
    </body>
</html>"
	# remove # from Include of httpd-vhosts.conf
	sed 's/^#Include conf\/extra\/httpd-vhosts.conf/Include conf\/extra\/httpd-vhosts.conf/' "${HTTPD_CONF}" &> "${TMP}"
	mv $TMP $CONF

	# remove all examples but keep comments
	grep "#" "${EXTRA_CONF}" &> "${TMP}"
	echo -e "${DEFAULT_HOST}" >> "${TMP}"
	mv $TMP $EXTRA_CONF
	echo "${EXTRA_CONF} updated"

	# create vhosts conf directory
	mkdir /etc/httpd/conf/extra/vhosts.d

	# create two example vhosts
	mkdir /srv/http/vhost1
	mkdir /srv/http/vhost2

	echo -e "${VHOST_EXAMPLE_1}" &> /etc/httpd/conf/extra/vhosts.d/vhost1.localhost.conf
	echo -e "${VHOST_EXAMPLE_2}" &> /etc/httpd/conf/extra/vhosts.d/vhost2.localhost.conf

	echo -e "127.0.0.1\tvhost1.localhost" >> /etc/hosts
	echo -e "127.0.0.1\tvhost2.localhost" >> /etc/hosts

	echo $HTML1 > "/srv/http/vhost1/index.html"
	echo $HTML2 > "/srv/http/vhost2/index.html"
}
install_apache(){
	# 
	if [ `pacman -Q apache &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S apache --noconfirm
	fi
	# lynx needed for apachectl
	if [ `pacman -Q lynx &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S lynx --noconfirm
	fi

	echo -e "127.0.0.1\t$HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts
	sed "s/^#ServerName.*/ServerName ${HOSTNAME}.${DOMAIN}:80/" $CONF &> $TMP
	mv $TMP $CONF
	
	echo "ServerName $HOSTNAME.$DOMAIN:80 added to $CONF" 

	echo $HTML > "${INDEX}"
	echo "$INDEX created"
	
}

# variables
HOSTNAME=`cat /etc/hostname`
DOMAIN="localdomain"
INDEX="/srv/http/index.html"
TMP="/tmp/apache_inst.tmp"
CONF="/etc/httpd/conf/httpd.conf"
HTML="<!DOCTYPE html>
<html lang="tr">
    <head>
        <meta charset="utf-8">
        <title>Merhaba dünya</title>
    </head>
    <body>
        <h1>Merhaba dünya</h1>
        <p>
            localhost - apache çalışıyor
        </p>
    </body>
</html>"

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 2>&1
	echo "sudo ${0}"
	exit 1
fi

install_apache
vhost

#/etc/rc.d/httpd restart
apachectl restart
echo "installation finished"
echo "visit following sites"
echo -e "\t http://localhost"
echo -e "\t http://vhost1.localhost"
echo -e "\t http://vhost2.localhost"

exit 0
