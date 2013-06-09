#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' freetype-2.4.12.tar > NUL || fail_with freetype-2.4.12.tar - EPIC FAIL

cd /c/temp/gcc
mv freetype-2.4.12 src
mkdir build dest
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with freetype - EPIC FAIL
make all install || fail_with freetype - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest freetype-2.4.12
cd freetype-2.4.12
rm -rf bin lib/pkgconfig lib/*.la share

7za -mx0 a ../freetype-2.4.12.7z *
