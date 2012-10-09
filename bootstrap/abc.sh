#!/bin/bash
for i in `cat packages.install` ; do
#	pacman -S "${i}"
	pacman -Q "${i}" &> /dev/null ; echo $?
done
