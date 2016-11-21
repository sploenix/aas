#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

infoMessage "Setting up system to run Diablo III using wine-staging"

# install wine-staging
! pkgIsInstalled wine-staging && {
  infoMessage "Installing package wine-staging ... "
  archInstallAsNeeded wine-staging
  ! pkgIsInstalled wine-staging && error "Failed to install package wine-staging" || okMessage "successfully installed package wine-staging!"
}
