#!/bin/bash
LFS_DISK="$1"

if [ -z "$LFS_DISK" ]; then
    echo "Error: Please specify the disk device (e.g., /dev/sda)"
    exit 1
fi

sudo fdisk "$LFS_DISK" << EOF
o
n
p
1

+100M
a
n
p
2


p
w
EOF
sudo mkfs -t ext2 -F "${LFS_DISK}1"
sudo mkfs -t ext2 -F "${LFS_DISK}2"
