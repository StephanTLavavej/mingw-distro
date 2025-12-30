#!/bin/sh

source ./0_append_distro_path.sh

untar_file libpng-1.6.53.tar

cd $X_WORK_DIR
mv libpng-1.6.53 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# Set ZLIB_ROOT to pick it up from the distro instead of /mingw64/bin.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DPNG_SHARED=OFF" \
"-DZLIB_ROOT=$X_DISTRO_ROOT" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest libpng-1.6.53
cd libpng-1.6.53
rm -rf bin include/libpng16 lib/cmake lib/libpng lib/pkgconfig lib/libpng16.a share

7z -mx0 a ../libpng-1.6.53.7z *
