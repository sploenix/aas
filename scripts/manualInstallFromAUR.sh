#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

requireNonRoot

[ -z "$1" ] && {
	error "ERROR: No package name given!"
}

manualBuildFromAUR $1
