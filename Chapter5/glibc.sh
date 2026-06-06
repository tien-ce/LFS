# The Glibc package contains the main C library. This library provides the basic routines for allocating memory, searching
# directories, opening and closing files, reading and writing files, string handling, pattern matching, arithmetic, and so on

# First, create a symbolic link for LSB compliance. Additionally, for x86_64, create a compatibility symbolic link required for proper operation of the dynamic library loader:
case $(uname -m) in
 i?86) ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
 ;;
 x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
 ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
 ;;
esac

# Some of the Glibc programs use the non-FHS-compliant /var/db directory to store their runtime data
patch -Np1 -i ../glibc-2.42-fhs-1.patch

mkdir -v build
cd build

# Ensure that the ldconfig and sln utilities are installed into /usr/sbin:
echo "rootsbindir=/usr/sbin" > configparms

# Next, prepare Glibc for compilation:
../configure \
 --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(../scripts/config.guess) \
 --disable-nscd \
 libc_cv_slibdir=/usr/lib \
 --enable-kernel=5.4

make
# doublecheck that the environment is correctly set, and that you are not root, before running the following command
make DESTDIR=$LFS install

# Fix a hard coded path to the executable loader in the ldd script:
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

# Now that our cross toolchain is in place, it is important to ensure that compiling and linking will work as expected.
# We do this by performing some sanity checks:
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

# Now make sure that we're set up to use the correct start files:
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log

# Verify that the compiler is searching for the correct header files:
grep -B3 "^ $LFS/usr/include" dummy.log

# Next, verify that the new linker is being used with the correct search paths:
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# Next make sure that we're using the correct libc:
grep "/lib.*/libc.so.6 " dummy.log

# Make sure GCC is using the correct dynamic linker:
grep found dummy.log

