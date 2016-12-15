#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# script must not be run as root
requireNonRoot

infoMessage "Installing required packages..."
archInstallAsNeeded pam_mount sssd
manualBuildFromAUR realmd
manualBuildFromAUR adcli

SysConfDir=/etc/aas

DOMAIN=`cat $SysConfDir/sssd | grep 'DOMAIN=' | cut -d= -f2`
TESTUSER=`cat $SysConfDir/sssd | grep 'TESTUSER=' | cut -d= -f2`
