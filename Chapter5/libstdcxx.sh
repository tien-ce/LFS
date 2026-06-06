mkdir -v build
cd build

# Prepare Libstdc++ for compilation:
../libstdc++-v3/configure \
 --host=$LFS_TGT \
 --build=$(../config.guess) \
 --prefix=/usr \
 --disable-multilib \
 --disable-nls \
 --disable-libstdcxx-pch \
 --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0

make
make DESTDIR=$LFS install

# Remove the libtool archive files because they are harmful for cross-compilation:
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
