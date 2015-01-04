#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' freetype-2.5.5.tar > NUL || fail_with freetype-2.5.5.tar - EPIC FAIL

cd /c/temp/gcc
mv freetype-2.5.5 src
mkdir build dest
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest "CFLAGS=-s -O3" --without-png || fail_with freetype - EPIC FAIL
make all install || fail_with freetype - EPIC FAIL
cd /c/temp/gcc
rm -rf build src PaxHeaders.*
mv dest freetype-2.5.5
cd freetype-2.5.5
rm -rf bin lib/pkgconfig lib/*.la share

7z -mx0 a ../freetype-2.5.5.7z *
