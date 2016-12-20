#!/bin/bash

# install unzip
pacman -S --noconfirm unzip

wget https://github.com/sploenix/aas/archive/master.zip
unzip -q master.zip -d aas
cd aas/scripts/install

./createNewPartitionLayout.sh

./installBaseSystem.sh /mnt
