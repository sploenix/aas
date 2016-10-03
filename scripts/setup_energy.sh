#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

requireNonRoot
requireIsArch

archInstallAsNeeded "powertop"

[ ! -f "/usr/bin/sensors-detect" ] && {
	# install package lm_sensors
	sysMessage "Installing package lm_sensors..."
	archInstallAsNeeded lm_sensors

	# detect sensors - all questions will be answered with default choice
	sysMessage "Detecting sensors..."
	(while :; do echo ""; done ) | sudo sensors-detect

	# enable and run lm_sensors service
	systemdEnable lm_sensors
	systemdRun lm_sensors

	sysMessage "Installing gnome-shell sensors extension..."
	archInstallAsNeeded gnome-shell-extension-freon
}
