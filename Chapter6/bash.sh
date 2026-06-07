# Prepare Bash for compilation:
./configure --prefix=/usr \
 --build=$(sh support/config.guess) \
 --host=$LFS_TGT \
 --without-bash-malloc

# Compile the package:
make
# Install the package:
make DESTDIR=$LFS install
# Make a link for the programs that use sh for a shell:
ln -sv bash $LFS/bin/sh
