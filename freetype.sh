#!/bin/sh

source ./0_append_distro_path.sh

untar_file freetype-2.11.0.tar

patch -d $X_WORK_DIR/freetype-2.11.0 -p1 < freetype-fix-cmake-mingw.patch

cd $X_WORK_DIR
mv freetype-2.11.0 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest freetype-2.11.0
cd freetype-2.11.0
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../freetype-2.11.0.7z *
