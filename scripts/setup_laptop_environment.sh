#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/sys_functions.sh

# script must be run as root
requireNonRoot

archInstallAsNeeded "powertop tlp tlp-rdw"

systemdEnable tlp
systemdRun tlp
