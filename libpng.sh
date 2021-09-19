#!/bin/sh

source ./0_append_distro_path.sh

untar_file libpng-1.6.37.tar

cd /c/temp/gcc
mv libpng-1.6.37 src
mkdir build dest
cd build

cmake \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DM_LIBRARY=" \
"-DPNG_SHARED=OFF" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest libpng-1.6.37
cd libpng-1.6.37
rm -rf bin include/libpng16 lib/libpng lib/pkgconfig lib/libpng16.a share

7z -mx0 a ../libpng-1.6.37.7z *
