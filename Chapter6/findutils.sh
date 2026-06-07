#Prepare Findutils for compilation:
./configure --prefix=/usr \
 --localstatedir=/var/lib/locate \
 --host=$LFS_TGT \
--build=$(build-aux/config.guess)
#Compile the package:
make
#Install the package:
make DESTDIR=$LFS install
