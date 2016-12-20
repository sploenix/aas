#!/bin/bash

wget https://github.com/sploenix/aas/archive/master.zip
unzip -q master.zip -d aas
cd aas/scripts/install

./createNewPartitionLayout.sh

./installBaseSystem.sh /mnt
