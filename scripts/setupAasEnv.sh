#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

BaseDir=`readlink -m $ScriptDir/../`
FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# script must not be run as root
requireNonRoot
requireIsArch

SysConfDir=/etc/aas
SysConfFile=$SysConfDir/config
CustomScriptDir=$SysConfDir/custom

# create SysConfDir
[ ! -d $SysConfDir ] && {
  infoMessage -n "Creating directory $SysConfDir ... "
  mkdir -p $SysConfDir
  [ -d $SysConfDir ] && okMessage "OK" || error "Failed"
}

# create CustomScriptDir
[ ! -d $CustomScriptDir ] && {
  infoMessage -n "Creating directory $CustomScriptDir ... "
  mkdir -p $CustomScriptDir
  [ -d $CustomScriptDir ] && okMessage "OK" || error "Failed"
}

# create main configuration file
[ ! -f $SysConfFile ] && {
  infoMessage -n "Creating file $SysConfFile ... "
  touch $SysConfFile
  [ -f $SysConfFile ] && okMessage "OK" || error "Failed"
}
