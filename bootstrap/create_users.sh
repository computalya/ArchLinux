#/etc/bin/bash
# create a user and give sudo permissions
# 
# VARIABLES
USERNAME="computalya"
CHECK=`cat /etc/passwd | cut -d":" -f1 | grep "${USERNAME}" &> /dev/null ; echo $?`
CHECK_SUDO=`cat /etc/passwd | cut -d":" -f1 | grep "${USERNAME}" &> /dev/null ; echo $?`

# main program
# if user does not exists...
if [ "${CHECK}" != "0" ] ; then
        useradd -m -g users -G locate,storage,wheel -s /bin/bash "${USERNAME}"
        echo "type a password for user : ${USERNAME}"
        passwd "${USERNAME}"
	else
		echo "user ${USERNAME} exists already. nothing to do"
fi

# add user to sudoer
# check whether sudo is installed
if [ "${CHECK_SUDO}" != "0" ] ; then
	echo "sudo is not installed. do pacman -S sudo"
	exit 1
	else
		echo "${USERNAME} ALL=(ALL) ALL" >> /etc/sudoers
		echo "sudoers udpated"
fi


exit 0
