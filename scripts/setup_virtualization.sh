#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

requireNonRoot
requireIsArch

# parse script parameters
for (( i=1; i<=$#; i++)); do
	if [ "${!i}" = "-a" ] || [ "${!i}" = "--auto" ]; then
    AUTO="1"
	fi
done

echo -e "${MAIN_MSG_COLOR}Setting up system for for virtualization using ${COff}\
libvirt ${MAIN_MSG_COLOR}and${COff} virt-manager${MAIN_MSG_COLOR} ...${COff}"

archInstallAsNeeded `cat $SPATH/package_lists/libvirt_environment.txt`

# Enable and start services
systemdEnable libvirtd
systemdRun libvirtd
systemdEnable virtlogd.socket
systemdRun virtlogd.socket

MYUSER=`whoami`
# Add user to group libvirt
if [ -z "`id -nG | grep libvirt`" ]; then
  if [ "$AUTO" = "1" ]; then
    echo -e "${MAIN_MSG_COLOR}Adding user $MYUSER to group libvirt$COff"
    sudo usermod -a -G "libvirt" $MYUSER
  else
    echo -en "${MAIN_MSG_COLOR}Add user $MYUSER to group libvirt?$COff"
    read -p " [Y/n] " YN
    if [[ "$YN" == "Y" || "$YN" == "y" || -z $YN ]]; then
      sudo usermod -a -G "libvirt" $MYUSER
    fi
  fi
fi
