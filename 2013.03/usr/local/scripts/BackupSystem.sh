#/bin/bash
# /usr/local/scripts not needed to backup -> GitHub
# /etc -aliases- on GitHub
# cronjobs also not needed
# /srv/ftp empty

# TO DO
# mysql databases???
#
BACKUP_DIR="/usr/local/BACKUP"
DATE=`date +%G%m%d%H%M`
mkdir "${BACKUP_DIR}/${DATE}"

# /root
mkdir "${BACKUP_DIR}/${DATE}/root"
cp /root/* "${BACKUP_DIR}/${DATE}/root"

# /etc
mkdir "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/profile "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/rc.conf "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/locale.gen "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/banner_ssh "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/dhcpcd.conf "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/hosts* "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/hostname "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/pure* "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/resolv.conf "${BACKUP_DIR}/${DATE}/etc"
cp -p /etc/vconsole.conf "${BACKUP_DIR}/${DATE}/etc"

cp -R /etc/httpd "${BACKUP_DIR}/${DATE}/etc"
cp -R /etc/conf.d "${BACKUP_DIR}/${DATE}/etc"
cp -R /etc/cups "${BACKUP_DIR}/${DATE}/etc"
cp -R /etc/profile.d "${BACKUP_DIR}/${DATE}/etc"
cp -R /etc/ssh "${BACKUP_DIR}/${DATE}/etc"
cp -R /etc/samba "${BACKUP_DIR}/${DATE}/etc"

# /srv/http/www
cp -R /srv/http/www "${BACKUP_DIR}/${DATE}/www"
tar -cvf  "${BACKUP_DIR}/${DATE}.tar"  "${BACKUP_DIR}/${DATE}"
gzip "${BACKUP_DIR}/${DATE}.tar"
rm -rf "${BACKUP_DIR}/${DATE}"
