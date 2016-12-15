#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && export ScriptDir=`pwd` || export ScriptDir=`dirname $0`

export BaseDir=`readlink -m $ScriptDir/../`
export FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

requireNonRoot

sysMessage "Installing latex environment..."
archInstallAsNeeded /etc/aas/packageConfiguration/latex.txt
