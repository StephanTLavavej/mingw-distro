#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' libpng-1.5.14.tar > NUL || fail_with libpng-1.5.14.tar - EPIC FAIL

cd /c/temp/gcc
mv libpng-1.5.14 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libpng - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with libpng - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.5.14
cd libpng-1.5.14
rm -rf bin include/libpng15 lib/pkgconfig lib/*.la lib/libpng15.a share

7za -mx0 a ../libpng-1.5.14.7z *
