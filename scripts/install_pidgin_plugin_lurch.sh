#!/bin/bash

VER="0.6.5"

[ -f `which pacman` ] && {
	echo "Detected Arch Linux"

	# install dependencies
	echo "Installing dependencies..."
	sudo -u root pacman -S --noconfirm --needed mxml sqlite libxml2 libgcrypt
}

# install lurch plugin to user plugin directory
echo "Fetching binary plugin..."
wget https://github.com/gkdr/lurch/releases/download/v$VER/lurch-$VER.so \
	-P ~/.purple/plugins
