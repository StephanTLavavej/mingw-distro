#!/bin/sh

source ./0_append_distro_path.sh

untar_file freetype-2.11.0.tar

patch -d /c/temp/gcc/freetype-2.11.0 -p1 < freetype-fix-cmake-mingw.patch

cd /c/temp/gcc
mv freetype-2.11.0 src
mkdir build dest
cd build

cmake \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest freetype-2.11.0
cd freetype-2.11.0
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../freetype-2.11.0.7z *
