#As in the first build of GCC, the GMP, MPFR, and MPC packages are required. Unpack the tarballs and move them into the required directories:
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

#If you are building on x86_64, change the default directory name for 64-bit libraries to “lib”:
case $(uname -m) in
 x86_64)
 sed -e '/m64=/s/lib64/lib/' \
 -i.orig gcc/config/i386/t-linux64
 ;;
esac

#Override the build rules of the libgcc and libstdc++ headers to allow building these libraries with POSIX threads support:
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
 -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
#Create a separate build directory again:
mkdir -v build
cd build
#Before starting to build GCC, remember to unset any environment variables that override the default optimization flags.
#Now prepare GCC for compilation:
../configure \
 --build=$(../config.guess) \
 --host=$LFS_TGT \
 --target=$LFS_TGT \
 --prefix=/usr \
 --with-build-sysroot=$LFS \
 --enable-default-pie \
 --enable-default-ssp \
 --disable-nls \
 --disable-multilib \
 --disable-libatomic \
 --disable-libgomp \
 --disable-libquadmath \
 --disable-libsanitizer \
 --disable-libssp \
 --disable-libvtv \
 --enable-languages=c,c++ \
 LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc

#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
#As a finishing touch, create a utility symlink. Many programs and scripts run cc instead of gcc, which is used to keep programs generic and therefore usable on all kinds of UNIX systems where the GNU C compiler is not always installed.  Running cc leaves the system administrator free to decide which C compiler to install:
ln -sv gcc $LFS/usr/bin/cc
