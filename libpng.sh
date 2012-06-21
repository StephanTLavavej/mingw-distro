#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' libpng-1.5.11.tar > NUL || { echo libpng-1.5.11.tar - EPIC FAIL ; exit 1; }

cd /c/temp/gcc
mv libpng-1.5.11 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || { echo libpng - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo libpng - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.5.11
cd libpng-1.5.11
rm -rf bin include/libpng15 lib/pkgconfig lib/*.la lib/libpng15.a share

7za -mx0 a ../libpng-1.5.11.7z *
