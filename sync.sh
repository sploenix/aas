#!/bin/bash

# path where this script is stored
SPATH=`dirname $0`
[ "$SPATH" = "." ] && SPATH=`pwd`
BASEDIR=$SPATH

# Store PID - kill script from within functions
# ...but only if this script is not called from another script
if [ -z "$TOP_PID" ]; then
	trap "exit 1" TERM
	export TOP_PID=$$
fi

## load color definitions
#source $SPATH/scripts/functions/color_definitions.sh
# load system functions
source $SPATH/functions/sys_functions.sh

requireNonRoot

# color of script messages
MAIN_MSG_COLOR=${Blue}

# Set username and Email for git usage
GCONFIG=~/.gitconfig
if [ -f $GCONFIG ]; then
	if [ -z "`cat $GCONFIG | grep 'email = '`" ]; then
		echo -e "${MAIN_MSG_COLOR}Settin}Setting email address for local git user${COff}"
		git config --global user.email "`whoami`@`hostname`"
	fi
	if [ -z "`cat $GCONFIG | grep 'name = '`" ]; then
		echo -e "${MAIN_MSG_COLOR}Setting name for local git user${COff}"
		USER_NAME=`whoami`
		REAL_NAME=`getent passwd $USER_NAME | cut -d':' -f5`
		git config --global user.name "$REAL_NAME"
	fi
	if [ -z "`cat $GCONFIG | grep 'default = '`" ]; then
		echo -e "${MAIN_MSG_COLOR}Setting simple pushing mode${COff}"
		git config --global push.default simple
	fi
else
	echo -e "${MAIN_MSG_COLOR}Setting default git options${COff}"
	git config --global user.email "`whoami`@`hostname`"
	USER_NAME=`whoami`
	REAL_NAME=`getent passwd $USER_NAME | cut -d':' -f5`
	git config --global user.name "$REAL_NAME"
	git config --global push.default simple
	git config --global core.editor "vim"
fi

OUT=`LANG=C git fetch -v 2>&1 | grep 'up to date'`
if [ -n "$OUT" ]; then
	echo -e "${MAIN_MSG_COLOR}No remote changes to pull${COff}"
else
	echo -e "${MAIN_MSG_COLOR}Pulling remote changes from repository${COff}"
	git pull | grep ' | '
fi

MSG="Pushing local changes on `hostname`"
OUT=`LANG=C git commit --all -m "$MSG" | grep 'Your branch is up-to-date'`
#echo $OUT
if [ -z "$OUT" ]; then
	echo -e "${MAIN_MSG_COLOR}Pushing local changes to remote repository${COff}"
	git push -q
else
	echo -e "${MAIN_MSG_COLOR}No local changes to push${COff}"
fi
cd $OLDPATH
