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

# create global configuration directory
[ ! -d $SysConfDir ] && {
	infoMessage -n "Creating directory $SysConfDir ... "
	sudo mkdir $SysConfDir
	[ ! -d $SysConfDir ] && error "Could not create directory $SysConfDir" || okMessage "OK"
}

# create global configuration file
[ ! -f $SysConfFile ] && {
	infoMessage -n "Creating file `readlink -m $SysConfFile` ... "
	sudo touch $SysConfFile
	[ ! -f $SysConfFile ] && error "Failed to create file `readlink -m $SysConfFile`" || okMessage "OK"
}

# create custom scripts directory
[ ! -d $CustomScriptDir ] && {
	infoMessage -n "Creating directory $CustomScriptDir ... "
	sudo mkdir $CustomScriptDir
	[ ! -d $CustomScriptDir ] && error "Could not create directory $CustomScriptDir" || okMessage "OK"
}

# add self update option
[ -z "`grep 'SELF_UPDATE=true' $SysConfFile`" ] && {
  infoMessage "Adding self update option to AAS config file"
  echo "# run self update" | sudo tee --append $SysConfFile
  echo "SELF_UPDATE=true" | sudo tee --append $SysConfFile
}

# User environment

# create ~/.bashrc
UserBashCfg=~/.bashrc
[ ! -f $UserBashCfg ] && {
	sysMessage -n "Creating file `readlink -m $UserBashCfg` ... "
	touch $UserBashCfg
	[ ! -f $UserBashCfg ] && error "Failed to create file `readlink -m $UserBashCfg`" || okMessage "OK"
}

# modify ~/.bashrc
PathStr=~/.aas
[ -z "`cat $UserBashCfg | grep PATH=`" ] && {
	sysMessage -n "Adding PATH defintion to bash configuration file $UserBashCfg ... "
	echo "export PATH=\$PATH:$PathStr" > $UserBashCfg
	[ -z "`cat $UserBashCfg | grep PATH`" ] && error "Failed" || okMessage "OK"
} || {
	[ -z "`cat $UserBashCfg | grep $PathStr`" ] && {
		sysMessage -n "Adding $PathStr to user PATH ... "
		OldPathStr=`cat $UserBashCfg | grep PATH=`
		NewPathStr="$OldPathStr:$PathStr"
		sed "s|$OldPathStr|$NewPathStr|g" -i $UserBashCfg
		[ -z "`cat $UserBashCfg | grep $PathStr`" ] && error "Failed" || okMessage "OK"
	}
}
