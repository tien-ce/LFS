#!/bin/bash


export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sda

if ! grep -q "$LFS" /proc/mounts; then
        source setupdisk.sh "$LFS_DISK"
	sudo mkdir -pv "$LFS"
	sudo mount "${LFS_DISK}2" "$LFS"
	sudo chown -v "$USER" "$LFS"
fi

mkdir -pv $LFS/tools
mkdir -pv $LFS/sources

mkdir -pv $LFS/boot
mkdir -pv $LFS/etc
mkdir -pv $LFS/bin
mkdir -pv $LFS/lib
mkdir -pv $LFS/sbin
mkdir -pv $LFS/usr
mkdir -pv $LFS/var

case $(uname -m) in
 x86_64) mkdir -pv $LFS/lib64 ;;
esac

cp -rf .env *.py *.sh Chapter* packages.csv "$LFS/sources"
cd "$LFS/sources"
export PATH="$LFS/tools/bin:$PATH"

source download.sh
# Chapter 5
#for package in binutils gcc linux-api-headers glibc libstdcxx ; do
#	source packages_install.sh 5 $package 
#done

# Chapter 6
for package in m4 ncurses bash coreutils diffutils file findutils gawk grep gzip make patch sed tar xzutils binutils gcc; do
    python3 packages_install.py 6 $package
	#source packages_install.sh 6 $package 
done
