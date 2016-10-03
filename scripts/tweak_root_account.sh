#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

# script must be run as root
requireRoot

###
### VIM
###
CFILE="/etc/vimrc"
if [ -z "`cat $CFILE | grep 'syntax on'`" ]; then
	echo -e "${Blue}Enabling syntax highlighting for vim${COff}"
	echo "syntax on" >> $CFILE
fi
if [ -z "`cat $CFILE | grep 'set tabstop=4'`" ]; then
    echo -e "${Blue}Setting tab width for vim to 4 spaces${COff}"
    echo "set tabstop=4" >> $CFILE
fi

###
### SSH
###
CFILE=root/.ssh/config
if [ -f "/$CFILE" ]; then
	if [ -n "`diff $SPATH/../$CFILE /$CFILE`" ]; then
		echo -e "${Blue}Updating ssh configuration file ${COff}/$CFILE"
		cp $SPATH/../$CFILE /$CFILE
	fi
else
	echo -e "${Blue}Creating ssh configuration file ${COff}/$CFILE"
	cp $SPATH/../$CFILE /$CFILE
fi
