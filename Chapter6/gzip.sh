#Prepare Gzip for compilation:
./configure --prefix=/usr --host=$LFS_TGT
#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
