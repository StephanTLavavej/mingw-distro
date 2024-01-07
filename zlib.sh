#!/bin/sh

source ./0_append_distro_path.sh

untar_file zlib-1.3.tar

cd $X_WORK_DIR
mv zlib-1.3 src
mkdir build dest
cd build

# -DTOO_FAR=32767 : http://optipng.sourceforge.net/pngtech/too_far.html
# -DMINGW=TRUE : zlib's CMakeLists.txt checks MINGW, but CMake 3.28.1 doesn't define it.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3 -DTOO_FAR=32767" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DMINGW=TRUE" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest zlib-1.3
cd zlib-1.3
rm -rf bin lib/libz.dll.a share

7z -mx0 a ../zlib-1.3.7z *
