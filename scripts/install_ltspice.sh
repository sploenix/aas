#!/bin/bash

# path where this script is stored
[ "`dirname $0`" = "." ] && SCRIPTPATH=`pwd` || SCRIPTPATH=`dirname $0`
BASEDIR=`readlink -m $SCRIPTPATH/../`

# load system functions
source $BASEDIR/functions/sys_functions.sh

requireNonRoot
requireIsArch

# CREATE A TMP-WORKING-DIR AN NAVIGATE TO IT
mkdir -p /tmp/pacaur_install
cd /tmp/pacaur_install

# INSTALL dependencies for compiling packages
echo "Checking build environment..."
archInstallAsNeeded "binutils gcc fakeroot make"

# INSTALL DEPENDENCY "cower" FROM AUR
echo "Installing ltspice from AUR..."
cower -d ltspice
cd /tmp/pacaur_install/ltspice
makepkg
sudo pacman --noconfirm --needed -U ltspice*.tar.xz

# CLEAN THE TMP-WORKING-DIR
cd ~
rm -rf /tmp/pacaur_install

# INSTALL DEPENDENCY "expac", "yajl" AND "git" FROM EXTRA
echo "Installing dependencies ..."
archInstallAsNeeded "wine_gecko lib32-mpg123 lib32-gstreamer"
