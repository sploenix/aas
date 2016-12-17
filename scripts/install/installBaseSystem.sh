#!/bin/bash

swapon /dev/sda1

mount /dev/sda2 /mnt

mkdir /mnt/home

mount /dev/sda3 /mnt/home

pacstrap /mnt base base-devel networkmanager openssh sudo vim git

genfstab -L /mnt > /mnt/etc/fstab

arch-chroot /mnt
