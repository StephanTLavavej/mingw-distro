#!/bin/sh

source ./0_append_distro_path.sh

untar_file zlib-1.2.11.tar

cd /c/temp/gcc
mv zlib-1.2.11 src
mkdir build dest
cd build

# -DTOO_FAR=32767 : http://optipng.sourceforge.net/pngtech/too_far.html
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3 -DTOO_FAR=32767" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest zlib-1.2.11
cd zlib-1.2.11
rm -rf bin lib/libz.dll.a share

7z -mx0 a ../zlib-1.2.11.7z *
