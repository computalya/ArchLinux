# ArchLinux
===

My ArchLinux settings and scripts

## current releases
+ genfstab -p /mnt >> /mnt/etc/fstab
+ arch-chroot /mnt
+ pacman -S git
+ git clone https://github.com/computalya/ArchLinux
+ cd ArchLinux/2012.10_systemd/bootstrap

## for older versions with /etc/rc.conf support
+ genfstab -p /mnt >> /mnt/etc/fstab
+ arch-chroot /mnt
+ pacman -S git
+ git clone https://github.com/computalya/ArchLinux
+ cd ArchLinux/2012.10_rc_conf/bootstrap
+ read README.md
