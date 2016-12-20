#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && BaseDir=`pwd` || BaseDir=`dirname $0`

FunctionsDir=`readlink -m $BaseDir/functions`

# load system functions
source $FunctionsDir/arch_functions.sh

# check if aas was cloned from git
[ ! -d $BaseDir/.git ] && {
  infoMessage "Self update only works using the git version of aas!"
  exit 0
}

infoMessage "Running self update of aas"

# switch to aas directory
OldPwd=`pwd` && cd $BaseDir

# update from git
git fetch && git pull

# switch back to stored directory
cd $OldPwd

exit 0
