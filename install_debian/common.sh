#!/bin/bash

sudo mkdir -p /target

# install Debian bookworm
sudo DEBOOTSTRAP_DIR=/usr/share/debotstrap debootstrap\
 --force-check-gpg\
 --variant=minbase\
 --components=main,contrib,non-free\
 --include=ca-certificates\
 bookworm /target https://deb.debian.org/debian/

sudo sh -c 'for i in dev dev/pts proc sys ;do mount --bind /$i /target/$i;done'

# update cache
sudo tee /target/etc/apt/sources.list <<__EOF__
deb https://deb.debian.org/debian bookworm main contrib non-free
deb https://deb.debian.org/debian bookworm-updates main contrib non-free
deb https://deb.debian.org/debian bookworm-backports main contrib non-free
deb https://deb.debian.org/debian-security bookworm-security main contrib non-free
__EOF__
sudo chroot /target /bin/sh -c 'apt-get update'

# install apps
:|sudo chroot /target /bin/sh -c 'DEBIAN_FRONTEND=noninteractive apt-get -f -y install'
sudo chroot /target /bin/sh -c 'apt-get clean'
:|sudo chroot /target /bin/sh -c 'DEBIAN_FRONTEND=noninteractive apt-get -y install $@' --\
 nftables\
 spectre-meltdown-checker\
 procps\
 fdisk\
 sudo\
 nano\
 less\
 tmux\
 zstd\
 unar\
 iproute2\
 bash-completion\
 network-manager\
 wpasupplicant\
 cryptsetup\
 dosfstools\
 ntfs-3g\
 xfsprogs\
 btrfs-progs\
 exfatprogs\
 lvm2\
 cryptsetup\
 gdm3\
 foot\
 firefox-esr\
 phosh\
 pciutils\
 usbutils\
 grub-efi\
 firmware-linux\
 firmware-realtek\
 intel-microcode\
 linux-image-amd64

sudo chroot /target /bin/sh -c 'apt-get clean'

# configure firewall
sudo tee /target/etc/nftables.conf <<__EOF__
#!/usr/sbin/nft -f

flush ruleset

table inet filter {
	chain input {
		type filter hook input priority filter;policy drop;
		ct state related,established accept
		iifname "lo" accept
	}
	chain forward {
		type filter hook forward priority filter;policy drop;
	}
	chain accept {
		type filter hook output priority filter;policy accept;
	}
}
__EOF__

# create sudo-privileged user user without password
sudo chroot /target /bin/sh -c 'useradd -G sudo -m -s /bin/bash -u -U user'
sudo chroot /target /bin/sh -c 'passwd -d user'
sudo tee /etc/sudoers.d/nopasswd <<__EOF__
%sudo ALL=(ALL:ALL) NOPASSWD: ALL
__EOF__

sudo sh -c 'for i in dev/pts dev proc sys ;do umount /target/$i;done'

