#Binutils building system relies on an shipped libtool copy to link against internal static libraries, but the libiberty and zlib copies shipped in the package do not use libtool. This inconsistency may cause produced binaries mistakenly linked against libraries from the host distro. Work around this issue:
sed '6031s/$add_dir//' -i ltmain.sh
#Create a separate build directory again:
mkdir -v build
cd build
#Prepare Binutils for compilation:
../configure \
 --prefix=/usr \
 --build=$(../config.guess) \
 --host=$LFS_TGT \
 --disable-nls \
 --enable-shared \
 --enable-gprofng=no \
 --disable-werror \
 --enable-64-bit-bfd \
 --enable-new-dtags \
 --enable-default-hash-style=gnu

#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
#Remove the libtool archive files because they are harmful for cross compilation, and remove unnecessary static libraries:
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
