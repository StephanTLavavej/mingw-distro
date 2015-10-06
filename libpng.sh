#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' libpng-1.6.18.tar > /dev/null || fail_with libpng-1.6.18.tar - EPIC FAIL

cd /c/temp/gcc
mv libpng-1.6.18 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libpng - EPIC FAIL
# Adding -P is necessary to avoid problems with linemarkers.
make all install "CFLAGS=-s -O3" "DFNCPP=gcc -E -P" || fail_with libpng - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.6.18
cd libpng-1.6.18
rm -rf bin include/libpng16 lib/pkgconfig lib/*.la lib/libpng16.a share

7z -mx0 a ../libpng-1.6.18.7z *
