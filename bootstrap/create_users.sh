#/etc/bin/bash
#
# VARIABLES
USERNAME="computalya"
CHECK=`cat /etc/passwd | cut -d":" -f1 | grep "${USERNAME}" &> /dev/null ; echo $?`

# main program
# if user does not exists...
if [ "${CHECK}" != "0" ] ; then
        useradd -m -g users -G locate,storage,wheel -s /bin/bash "${USERNAME}"
        echo "type a password for user : ${USERNAME}
        passwd "${USERNAME}"
fi

exit 0