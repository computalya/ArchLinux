#!/bin/bash
install_archboot(){
	for i in `cat packages.install | sed 's/ *[#;].*$//g' | sed 's/^ *//' | sed '/^$/d'` ; do
		if [ ! `pacman -Q "${i}" &> /dev/null ; echo $?` == 0 ] ; then
			pacman -S "${i}" --noconfirm
		fi
	done
}

# main program
# check user 
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 2>&1
	echo "sudo ${0}"
	exit 1
fi

install_archboot

mkdir ~/archlive
cp -r /usr/share/archiso/configs/releng/ ~/archlive

cat packages.livecd &>> ~/archlive/releng/packages.i686

exit 1
pacman -Syu

exit 0
