#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

# generate kernel image
sysMessage "Generating kernel boot image..."
sudo mkinitcpio -p linux

sysMessage "Setting up grub..."
# install needed packages
archInstallAsNeeded "grub os-prober efibootmgr"

# generate grub configuration file
sudo grub-mkconfig -o /boot/grub/grub.cfg

# grep device of root partition
ROOT_DEV=`cat /etc/mtab | grep ' / ' | cut -d' ' -f1`
BOOT_DEV=`echo ${ROOT_DEV::-1}`

# install grub to mbr
sudo grub-install $BOOT_DEV
