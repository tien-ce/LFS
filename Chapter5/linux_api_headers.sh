# The Linux API Header expose the kernel's API for use by Glibc
# Make sure there are no stale files embedded in the package
make mrproper

# Now extract the user-visible kernel headers from the source
make headers
find usr/include -type f ! -name '*.h' -delete
# The headers are first placed in ./usr, then copied to the needed location.
cp -rv usr/include $LFS/usr
