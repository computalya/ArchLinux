#!/bin/bash
# Author        : Atilla Gündüz
# Filename	: apache_serenity.sh
# Description   : 
# Date          : 19. Oct. 2012
# Last updated  : 19. Oct. 2012
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
\tDocumentRoot /root/srv/http/
\tServerName localhost
\tServerAlias localhost
</VirtualHost>\n
Include conf/extra/vhosts.d/*.conf"

	VHOST_EXAMPLE_1="
<VirtualHost *:80>
\tDocumentRoot /root/srv/http/vhost1
\tServerName vhost1.localhost
\tServerAlias www.vhost1.localhost
</VirtualHost>"

	VHOST_EXAMPLE_2="
<VirtualHost *:80>
\tDocumentRoot /root/srv/http/vhost2
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
	if [ ! -d /etc/httpd/conf/extra/vhosts.d ] ; then
		mkdir -p /etc/httpd/conf/extra/vhosts.d
		echo "/etc/httpd/conf/extra/vhosts.d created"
		else
			echo "/etc/httpd/conf/extra/vhosts.d exists already"
			
	fi

	# create two example vhosts
	if [ ! -d /root/srv/http/vhosts1 ] ; then
		mkdir -p /root/srv/http/vhost1
		echo "/root/srv/http/vhost1 created"
		else
			echo "/root/srv/http/vhost1 exists already"

	fi

	if [ ! -d /root/srv/http/vhosts2 ] ; then
		mkdir -p /root/srv/http/vhost2
		echo "/root/srv/http/vhost2 created"
		else
			echo "/root/srv/http/vhost2 exists already"

	fi

	if [ ! -f /etc/httpd/conf/extra/vhosts.d/vhost1.localhost.conf ] ; then
		echo -e "${VHOST_EXAMPLE_1}" &> /etc/httpd/conf/extra/vhosts.d/vhost1.localhost.conf
		echo "/etc/httpd/conf/extra/vhosts.d/vhost1.localhost.conf created"
		else
			echo "/etc/httpd/conf/extra/vhosts.d/vhost1.localhost.conf exists already"
	fi

	if [ ! -f /etc/httpd/conf/extra/vhosts.d/vhost2.localhost.conf ] ; then
		echo -e "${VHOST_EXAMPLE_2}" &> /etc/httpd/conf/extra/vhosts.d/vhost2.localhost.conf
		echo "/etc/httpd/conf/extra/vhosts.d/vhost2.localhost.conf created"
		else
			echo "/etc/httpd/conf/extra/vhosts.d/vhost2.localhost.conf exists already"
	fi

#	HOSTS1=`grep "vhost1.localhost" "/etc/hosts" &> /dev/null ; echo $?`

#	if [ "${HOSTS1}" == "1" ] ; then
#		echo -e "127.0.0.1\tvhost1.localhost" >> /etc/hosts
#		echo "/etc/hosts updated"
#		else
#			echo -e "error: /etc/hosts includes already: 127.0.0.1\tvhost1.localhost"
#	fi

#	HOSTS2=`grep "vhost2.localhost" "/etc/hosts" &> /dev/null ; echo $?`
#	if [ "${HOSTS2}" == "1" ] ; then
#		echo -e "127.0.0.1\tvhost2.localhost" >> /etc/hosts
#		echo "/etc/hosts updated"
#		else
#			echo -e "error: /etc/hosts includes already: 127.0.0.1\tvhost2.localhost"
#	fi

	if [ ! -f /root/srv/http/vhost1/index.html ] ; then
		echo $HTML1 > "/root/srv/http/vhost1/index.html"
		echo "/root/srv/http/vhost1/index.html created"
		else
			echo "/root/srv/http/vhost1/index.html exists already"
	fi

	if [ ! -f /root/srv/http/vhost2/index.html ] ; then
		echo $HTML2 > "/root/srv/http/vhost2/index.html"
		echo "/root/srv/http/vhost1/index.html created"
		else
			echo "/root/srv/http/vhost2/index.html exists already"
	fi
}
install_apache(){
	# 
	if [ `pacman -Q apache &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S apache --noconfirm --noprogressbar
	fi
	# lynx needed for apachectl
	if [ `pacman -Q lynx &> /dev/null ; echo $?` != "0" ] ; then
		pacman -S lynx --noconfirm
	fi

	mkdir -p /root/srv/http

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
INDEX="/root/srv/http/index.html"
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
# /srv/http -> /root/srv/http
cat /etc/httpd/conf/httpd.conf | sed 's/\/srv/\/root\/srv/' &> "${TMP}"
mv $TMP /etc/httpd/conf/httpd.conf

systemctl enable httpd
# ln -s '/usr/lib/systemd/system/httpd.service' '/etc/systemd/system/multi-user.target.wants/httpd.service'

#serenity
cp -r /root/BACKUP/www/* /root/srv/http/
cp /root/BACKUP/etc/httpd/conf/extra/vhosts.d/* /etc/httpd/conf/extra/vhosts.d/
# update hosts file
for i in `ls -1 /etc/httpd/conf/extra/vhosts.d/*.conf` ; do
	FILE=`basename $i | sed 's/.conf//'` 
	echo -e "127.0.0.1\t$FILE www.$FILE" &>> /etc/hosts
done

apachectl restart
echo "installation finished"
echo "visit following sites"
echo -e "\t http://localhost"
echo -e "\t http://vhost1.localhost"
echo -e "\t http://vhost2.localhost"

exit 0
