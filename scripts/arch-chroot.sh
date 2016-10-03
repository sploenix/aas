#!/bin/bash

# predefined variables - adjust to your needs
TIMEZONE="Europe/Berlin"
LANG="de_DE"
KEYMAP="de-latin1"

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $SCRIPTPATH/../functions/arch_functions.sh

# script must be run as root
requireRoot
requireIsArch

# update package database
pacman -Sqy
pacman -Sq --noconfirm --needed mc vim htop net-tools networkmanager dnsmasq openssh sudo

# german environment
echo -e "Configuring locales..."
echo LANG=${LANG}.UTF-8 > /etc/locale.conf
echo LC_COLLATE=C >> /etc/locale.conf
echo LANGUAGE=${LANG} >> /etc/locale.confi

# keyboard mapping
echo "Setting keyboard mapping..."
echo KEYMAP=${KEYMAP} > /etc/vconsole.conf

# time zone
echo "Setting Time Zone to ${TIMEZONE}..."
ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# locales
echo "Generating locales..."
sed -i "s/#${LANG}/${LANG}/g" /etc/locale.gen
locale-gen

# root password
echo "Setting new password for user root"
passwd

# setup boot loader (and generate kernel boot image)
$SCRIPTPATH/setup_grub.sh

echo "Configuring SSH"
systemdEnable sshd
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11Forwarding yes'`" ]; then
	echo -e "Enabling X11Forwarding"
	echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
fi
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11UseLocalhost no'`" ]; then
	echo -e "Disabling X11UseLocalhost"
	echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config
fi

echo "Enabling NetworkManager"
systemdEnable NetworkManager

echo -e "\nIf you don't see any errors you can reboot the system and start your installed system"
