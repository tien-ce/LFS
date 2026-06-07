#First, ensure some unneeded files are not installed:
sed -i 's/extras//' Makefile.in
#Prepare Gawk for compilation:
./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(build-aux/config.guess)
#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
