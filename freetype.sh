#!/bin/sh

source ./0_append_distro_path.sh

untar_file freetype-2.9.tar

cd /c/temp/gcc
mv freetype-2.9 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest "CFLAGS=-s -O3"

make $X_MAKE_JOBS all
make install
cd /c/temp/gcc
rm -rf build src
mv dest freetype-2.9
cd freetype-2.9
rm -rf bin lib/pkgconfig lib/*.la share

7z -mx0 a ../freetype-2.9.7z *
