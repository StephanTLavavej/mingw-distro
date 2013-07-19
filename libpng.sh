#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' libpng-1.6.3.tar > NUL || fail_with libpng-1.6.3.tar - EPIC FAIL

cd /c/temp/gcc
mv libpng-1.6.3 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libpng - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with libpng - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.6.3
cd libpng-1.6.3
rm -rf bin include/libpng16 lib/pkgconfig lib/*.la lib/libpng16.a share

7za -mx0 a ../libpng-1.6.3.7z *
