#!/bin/sh

source ./0_append_distro_path.sh

7z x '-oC:\Temp\gcc' libpng-1.6.18.tar > /dev/null || fail_with libpng-1.6.18.tar - EPIC FAIL

cd /c/temp/gcc
mv libpng-1.6.18 src
mkdir build dest
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared || fail_with libpng - EPIC FAIL
# Adding -P is necessary to avoid problems with linemarkers.
make $X_MAKE_JOBS all "CFLAGS=-s -O3" "DFNCPP=gcc -E -P" || fail_with libpng - EPIC FAIL
make install || fail_with libpng - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.6.18
cd libpng-1.6.18
rm -rf bin include/libpng16 lib/pkgconfig lib/*.la lib/libpng16.a share

7z -mx0 a ../libpng-1.6.18.7z *
