#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

# script must be run as root
requireRoot

###
### Hostname
###
if [ ! -f "/etc/hostname" ]; then
	echo -en "${BRed}Please enter a host name for this computer:${COff}"
        read -p " " HNAME
	if [ -z "$HNAME" ]; then
		echo -e "${BRed}ERROR: no host name entered${COff}"
		exit
	fi
	echo -e "${Blue}Setting host name to $HNAME${COff}"
fi

###
### SSH configuration
###
if [ -z "`pacman -Qs xorg-xauth`" ]; then
	echo -e "${Blue}Installing package ${COff}xorg-xauth${Blue} to allow redirection of Xorg output${COff}"
	pacman -Ssq --needed --noconfirm xorg-xauth
fi
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11Forwarding yes'`" ]; then
        echo -e "${Blue}Enabling X11Forwarding${COff}"
        echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
fi
if [ -z "`cat /etc/ssh/sshd_config | grep 'X11UseLocalhost no'`" ]; then
        echo -e "${Blue}Disabling X11UseLocalhost${COff}"
        echo 'X11UseLocalhost no' >> /etc/ssh/sshd_config
fi
ISENABLED=`systemctl status sshd | grep "Loaded:" | awk '{print $4}' | cut -d';' -f1`
ISSTARTED=`systemctl status sshd | grep "Loaded:" | awk '{print $2}'`
if [ ! "$ISENABLED" == "enabled" ]; then
	echo -e "${Blue}Enabling SSH service${COff}"
	systemctl enable sshd
fi
systemctl restart sshd
