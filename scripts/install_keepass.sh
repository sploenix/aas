#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/scripts/functions/sys_functions.sh

requireNonRoot
requireIsArch

# install missing packages
echo -e "${Blue}Installing keepass2 (mono version) and plugins...${COff}"
archInstallAsNeeded "\
	keepass \
	keepass-de \
	keepass-plugin-favicon \
	keepass-plugin-http \
	keepass-plugin-keeagent \
	keepass-plugin-qualitycolumn \
	keepass-plugin-qrcodeview \
	keepass-plugin-rpc \
	xdotool \
	xsel"

	# install missing packages
	echo -e "${Blue}Installing keepassx with http plugin...${COff}"
	archInstallAsNeeded "keepassx-http"
