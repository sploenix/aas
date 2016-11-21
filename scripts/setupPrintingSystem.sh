#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# always run in user mode
requireNonRoot
# only run on arch based distributions
requireIsArch

sysMessage "Installing required packages..."
archInstallAsNeeded cups cups-pdf

systemdEnable org.cups.cupsd
systemdRun org.cups.cupsd

exit 0
