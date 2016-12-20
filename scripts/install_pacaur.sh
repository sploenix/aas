#!/bin/sh

# Base script comes from:
# https://gist.githubusercontent.com/Tadly/0e65d30f279a34c33e9b/raw/

# path where this script is stored

# path where this script is stored
[ "`dirname $0`" = "." ] && ScriptDir=`pwd` || ScriptDir=`dirname $0`
BaseDir=`readlink -m $ScriptDir/../`

# load system functions
source $BaseDir/functions/arch_functions.sh

requireNonRoot

# exit script if pacaur is installed
[ -f "/usr/bin/pacaur" ] && exit 0

# MAKE SURE OUR SHINY NEW ARCH IS UP-TO-DATE
infoMessage "Applying system updates..."
sudo pacman -Syu --noconfirm

# INSTALL dependencies for compiling packages
infoMessage "Checking build environment..."
archInstallAsNeeded "binutils gcc fakeroot make"

# INSTALL DEPENDENCY "expac", "yajl" AND "git" FROM EXTRA
infoMessage "Installing dependencies from repository EXTRA..."
archInstallAsNeeded  expac yajl git

# INSTALL DEPENDENCY "cower" FROM AUR
manualBuildFromAUR cower

# INSTALL "pacaur" FROM AUR
manualBuildFromAUR pacaur

# recheck pacaur Installation
[ -f "/usr/bin/pacaur" ] && exit 0 || error "Failed to build pacaur"
