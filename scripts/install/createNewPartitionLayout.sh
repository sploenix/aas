#!/bin/bash
#
# Erase complete disk, create new partition layout and format new partitions
#
# Labels:
# - /     : ARCH
# - /home : HOME
# - swap  : SWAP

DISK=sda
SWAP_SIZE=4G
EFI_SIZE=512M
ROOT_SIZE=30G

# TODO: use EFI if possible
[ -d /sys/firmware/efi ] && echo "System uses UEFI" || echo "System uses BIOS"

# complete path to harddisk device
DEV=/dev/$DISK

# TODO: use parted instead of fdisk (gpt support, ease of use)
echo -n "${DEV}: "
echo `fdisk -l $DEV | grep 'Disk /dev' | awk '{print $3 $4}'`
echo "Will delete all data on $DEV - press CTRL-C to exit or any other key to continue..."
read -n 1

echo "Creating new partition table on $DEV"
(
	echo o # Create a new empty DOS partition table
	echo w # Write changes
) | sudo fdisk $DEV

echo "Creating swap partition ${DEV}1"
(
	echo n # Add a new partition
	echo p # Primary partition
	echo 1 # Partition number
	echo   # First sector (Accept default: 1)
	echo +$SWAP_SIZE  # Last sector (Accept default: varies)
	echo t # set partition type
	echo 82 # swap partition
	echo w # Write changes
) | sudo fdisk $DEV

echo "Creating root partition ${DEV}2"
(
        echo n # Add a new partition
        echo p # Primary partition
        echo 2 # Partition number
        echo   # First sector (Accept default: 1)
        echo +$ROOT_SIZE  # Last sector (Accept default: varies)
        echo w # Write changes
) | sudo fdisk $DEV

echo "Creating home partition ${DEV}3"
(
        echo n # Add a new partition
        echo p # Primary partition
        echo 3 # Partition number
        echo   # First sector (Accept default: 1)
        echo   # Last sector (Accept default: varies)
	echo a # select boot partition
	echo 3 # root is bootable
        echo w # Write changes
) | sudo fdisk $DEV

echo "Formatting swap and set label to SWAP"
mkswap -L SWAP ${DEV}1

echo "Formatting root and set label to ARCH"
mkfs.ext4 -L ARCH ${DEV}2

echo "Formatting home and set label to HOME"
mkfs.ext4 -L HOME ${DEV}3
