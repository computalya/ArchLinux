#!/bin/bash
# /etc/httpd/conf/extra/vhosts.d/*.conf
for i in `ls -1 /etc/httpd/conf/extra/vhosts.d/*.conf` ; do
	FILE=`basename $i | sed 's/.conf//'` 
	echo -e "127.0.0.1\t$FILE www.$FILE" &>> /etc/hosts
done
