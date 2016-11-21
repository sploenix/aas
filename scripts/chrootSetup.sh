#!/bin/bash

# predefined variables - adjust to your needs
TIMEZONE="Europe/Berlin"
LANG="de_DE"
KEYMAP="de-latin1"

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# script must be run as root
requireRoot
requireIsArch

# update package database
pacman -Sqy
# install required packages
pacman -Sq --noconfirm --needed mc vim htop net-tools networkmanager dnsmasq openssh sudo git

# german environment
echo -e "Configuring locales..."
echo LANG=${LANG}.UTF-8 > /etc/locale.conf
echo LC_COLLATE=C >> /etc/locale.conf
echo LANGUAGE=${LANG} >> /etc/locale.conf

# set keyboard mapping
echo "Setting keyboard mapping..."
echo KEYMAP=${KEYMAP} > /etc/vconsole.conf

# set time zone
echo "Setting Time Zone to ${TIMEZONE}..."
ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# generate locales
echo "Generating locales..."
sed -i "s/#${LANG}/${LANG}/g" /etc/locale.gen
locale-gen

# check if root account has usable password
[ "`passwd --status root | awk '{print $2}'`" != "P" ] && {
	echo "Setting new password for user root"
	passwd
} || {
	echo "Root password already set"
}

# setup boot loader (and generate kernel boot image)
$ScriptDir/setupGrub.sh

echo "Configuring SSH"
systemdctl enable sshd
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11Forwarding yes'`" ]; then
	echo -e "Enabling X11Forwarding"
	echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
fi
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11UseLocalhost no'`" ]; then
	echo -e "Disabling X11UseLocalhost"
	echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config
fi

echo "Enabling NetworkManager"
systemdctl enable NetworkManager

echo -e "\nIf you don't see any errors you can reboot the system and start your installed system"
