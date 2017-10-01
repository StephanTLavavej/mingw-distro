#!/bin/sh

source ./0_append_distro_path.sh

untar_file libpng-1.6.32.tar

cd /c/temp/gcc
mv libpng-1.6.32 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared || fail_with libpng 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with libpng 2 - EPIC FAIL
make install || fail_with libpng 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.6.32
cd libpng-1.6.32
rm -rf bin include/libpng16 lib/pkgconfig lib/*.la lib/libpng16.a share

7z -mx0 a ../libpng-1.6.32.7z *
