#!/bin/sh

# Base script comes from:
# https://gist.githubusercontent.com/Tadly/0e65d30f279a34c33e9b/raw/

# path where this script is stored

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/arch_functions.sh

requireNonRoot

# exit script if pacaur is installed
[ -f "/usr/bin/pacaur" ] && exit 0

# MAKE SURE OUR SHINY NEW ARCH IS UP-TO-DATE
sysMessage "Checking for system updates..."
sudo pacman -Syu --noconfirm

# INSTALL dependencies for compiling packages
sysMessage "Checking build environment..."
archInstallAsNeeded "binutils gcc fakeroot make"

# INSTALL DEPENDENCY "expac", "yajl" AND "git" FROM EXTRA
sysMessage "Installing dependencies from repository EXTRA..."
archInstallAsNeeded  expac yajl git

# INSTALL DEPENDENCY "cower" FROM AUR
manualBuildFromAUR cower

# INSTALL "pacaur" FROM AUR
manualBuildFromAUR pacaur

# recheck pacaur Installation
[ -f "/usr/bin/pacaur" ] && exit 0 || error "Failed to build pacaur"
