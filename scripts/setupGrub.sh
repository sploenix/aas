#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && ScriptDir=`pwd` || ScriptDir=`dirname $0`
BaseDir=`readlink -m $ScriptDir/../`

# load system functions
source $BaseDir/functions/arch_functions.sh

# generate kernel image
infoMessage "Generating kernel boot image..."
sudo mkinitcpio -p linux

infoMessage "Setting up grub..."
# install needed packages
archInstallAsNeeded "grub os-prober efibootmgr dosfstools mtools"

# generate grub configuration file
sudo grub-mkconfig -o /boot/grub/grub.cfg

# grep device of root partition
ROOT_DEV=`cat /etc/mtab | grep ' / ' | cut -d' ' -f1`
BOOT_DEV=`echo ${ROOT_DEV::-1}`

# install grub to mbr
sudo grub-install $BOOT_DEV
