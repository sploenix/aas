#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# script must not be run as root
requireNonRoot

SysConfDir=/etc/aas

DOMAIN=`cat $SysConfDir/sssd | grep 'DOMAIN=' | cut -d= -f2`
DOMAIN_ADMIN=`cat $SysConfDir/sssd | grep 'DOMAIN_ADMIN=' | cut -d= -f2`
TESTUSER=`cat $SysConfDir/sssd | grep 'TESTUSER=' | cut -d= -f2`

[ -n "`getent passwd $TESTUSER`" ] && {
	okMessage "Already joined!"
	exit 0
}

infoMessage "Installing required packages..."
archInstallAsNeeded ntp pam_mount sssd openldap docbook-xsl xmlto packagekit pkg-config
! pkgIsInstalled adcli && manualBuildFromAUR adcli
! pkgIsInstalled realmd && manualBuildFromAUR realmd

infoMessage "(Re-)Starting NTP service..."
sudo systemctl enable ntpd && sudo systemctl restart ntpd

# join domain
infoMessage "Joining Domain $DOMAIN"
sudo realm join -v -U ${DOMAIN_ADMIN} ${DOMAIN}
