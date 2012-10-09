#/etc/bin/bash
#
# VARIABLES
TEXT="
# this has been added from ct_profile.sh
#
for PROFILE_SCRIPT in \$( ls /etc/profile.d/computalya/*.sh ); do
    . \$PROFILE_SCRIPT
done"

# chech user 
if [ "$(id -u)" != "0" ]; then
	echo “This script must be run as root” 2>&1
	echo "sudo ${0}"
	exit 1
fi


# main program
echo "${TEXT}" >> "/etc/profile"
cp -R ../etc/profile.d/computalya/ /etc/profile.d/computalya
