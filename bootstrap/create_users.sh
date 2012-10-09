#/etc/bin/bash
#
# VARIABLES
USERNAME="computalya"

# main program
# if user does not exists...
if [ "$(id -u)" != "0" ]; then
	useradd -m -g users -G locate,storage,wheel -s /bin/bash "${USERNAME}"
	echo "type a password for user : ${USERNAME} 
	passwd
fi

exit 0
