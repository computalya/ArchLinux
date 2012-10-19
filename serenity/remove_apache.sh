#!/bin/bash
apachectl stop
rm -rf /etc/httpd
rm -rf /srv/http

cat /etc/hosts | grep -v "serenity.localdomain" &> /tmp/remove.txt
mv /tmp/remove.txt /etc/hosts

cat /etc/hosts | grep -v "vhost" &> /tmp/remove.txt
mv /tmp/remove.txt /etc/hosts

rm -rf /root/srv

pacman -Rsn apache
