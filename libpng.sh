#!/bin/sh

source ./0_append_distro_path.sh

untar_file libpng-1.6.40.tar

cd $X_WORK_DIR
mv libpng-1.6.40 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DM_LIBRARY=" \
"-DPNG_SHARED=OFF" \
"-DZLIB_ROOT=$X_DISTRO_ROOT" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest libpng-1.6.40
cd libpng-1.6.40
rm -rf bin include/libpng16 lib/libpng lib/pkgconfig lib/libpng16.a share

7z -mx0 a ../libpng-1.6.40.7z *
