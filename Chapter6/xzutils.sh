#Prepare Xz for compilation:
./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(build-aux/config.guess) \
 --disable-static \
 --docdir=/usr/share/doc/xz-5.8.1
#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
#Remove the libtool archive file because it is harmful for cross compilation:
rm -v $LFS/usr/lib/liblzma.la
