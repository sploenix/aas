#!/bin/bash

# installation directory has to be given as a script parameter
TARGET=$1

# check if a parameter was given
[ -z "$TARGET" ] && {
  echo -e "ERROR: You have to give the target directory as a script parameter"
  exit 1
}

# create target directory if it doesn't exist
[ ! -d "$TARGET" ] && mkdir -p $TARGET

# check target directory exists
[ ! -d "$TARGET" ] && {
  echo -e "ERROR: target directory $TARGET could not be created"
  exit 1
}

echo -e "Enabling swap space with label SWAP..."
#swapon ${DEV}1
swapon LABEL=SWAP

echo -e "Mounting root partition with label ARCH at ${TARGET}"
#mount ${DEV}2 ${TARGET}
mount LABEL=ARCH ${TARGET}

echo -e "Mounting home partition with label HOME at ${TARGET}/home"
mkdir ${TARGET}/home
#mount ${DEV}3 ${TARGET}/home
mount LABEL=HOME ${TARGET}/home

echo -e "Installing base system in /mnt"
pacstrap ${TARGET} base base-devel networkmanager openssh sudo vim git

echo -e "Generating fstab (label-based) for newly installed system"
genfstab -L ${TARGET} > ${TARGET}/etc/fstab

echo -e "Changing root to newly installed system"
arch-chroot ${TARGET} /bin/bash
