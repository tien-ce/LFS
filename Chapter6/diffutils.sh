# Prepare Diffutils for compilation:
./configure --prefix=/usr \
 --host=$LFS_TGT \
 gl_cv_func_strcasecmp_works=y \
 --build=$(./build-aux/config.guess)
# Compile the package:
make
# Install the package:
make DESTDIR=$LFS install
