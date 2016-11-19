#!/bin/bash

# load bash color definitions
source $FunctionsDir/sys_functions.sh

function checkIsArch() {
	[ -f "/etc/arch-release" ]
}

function requireIsArch() {
	! checkIsArch && error "ERROR: This script can only be used on ARCH LINUX"
}

function pkgIsInstalled() {
  [ -n "`pacman -Qs $1`" ]
}

function pkgAURUpdatePending() {
  [ -n "`checkupdates-aur | grep $1`" ]
}

function archInstallAsNeeded() {
	# if the argument is a file name the function will be called again with the file contents
	[ -f "$1" ] && {
		archInstallAsNeeded `cat $1`
		return 0
	}

  # parse all parameters (packages)
  for arg; do
    # Check wether package is installed
    # if a package is not installed, it will be added to the list of packages to be installed
    ! pkgIsInstalled $arg && NEWINSTALL="$NEWINSTALL$arg "
  done

  # install packages that are not installed
  if [ -n "$NEWINSTALL" ]; then
    # root can only use pacman
		[ "`whoami`" = "root" ] && PKG_CMD="pacman -q --color always " || {
			# if pacaur is not yet installed we will use pacman
    	[ -f "/usr/bin/pacaur" ] && PKG_CMD="pacaur --noedit --silent " || PKG_CMD="sudo pacman -q --color always "
		}
    $PKG_CMD -S --needed --noconfirm $NEWINSTALL
  fi
}

function manualBuildFromAUR() {
  sysMessage "Manual building package $1 from AUR..."
  # store working directory
  DIRNOW=`pwd`
  # create temporary working directory for package build
  WORKDIR=/tmp/pacaur_install
  mkdir -p $WORKDIR && cd $WORKDIR

  sysMessage "Building package $1 from AUR..."
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=$1
  makepkg PKGBUILD --skippgpcheck
  sudo pacman -U --needed --noconfirm $1*.tar.xz

  # CLEAN THE TMP-WORKING-DIR
  cd $DIRNOW
  rm -rf $WORKDIR

  # check installation status
  if [ ! `pkgIsInstalled $1` ] || [ `pkgAURUpdatePending $1` ]; then
    return 0
  else
    error "Failed to build $1"
  fi
}

requireIsArch
