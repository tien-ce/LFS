# We install it in $LFS/tools, so that it is found in the PATH when needed:
mkdir build
pushd build
 ../configure --prefix=$LFS/tools AWK=gawk
 make -C include
 make -C progs tic
 install progs/tic $LFS/tools/bin
popd
# Prepare Ncurses for compilation:
./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(./config.guess) \
 --mandir=/usr/share/man \
 --with-manpage-format=normal \
 --with-shared \
 --without-normal \
 --with-cxx-shared \
 --without-debug \
 --without-ada \
 --disable-stripping \
 AWK=gawk

# Compile the package:
make
# Install the package:
make DESTDIR=$LFS install
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
 -i $LFS/usr/include/curses.h
