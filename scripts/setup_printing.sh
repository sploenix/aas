#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

# script must be run as root
requireNonRoot

sysMessage "Installing required packages..."
archInstallAsNeeded cups cups-pdf

systemdEnable org.cups.cupsd
systemdRun org.cups.cupsd
