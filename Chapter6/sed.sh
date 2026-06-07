#Prepare Sed for compilation:
./configure --prefix=/usr \
 --host=$LFS_TGT \
 --build=$(./build-aux/config.guess)
#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
