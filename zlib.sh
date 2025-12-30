#!/bin/sh

source ./0_append_distro_path.sh

untar_file zlib-1.3.1.tar

cd $X_WORK_DIR
mv zlib-1.3.1 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# -DTOO_FAR=32767 : https://optipng.sourceforge.net/pngtech/too_far.html
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3 -DTOO_FAR=32767" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DZLIB_BUILD_EXAMPLES=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest zlib-1.3.1
cd zlib-1.3.1
rm -rf bin lib/libzlib.dll.a share
# CMakeLists.txt sets the `OUTPUT_NAME` to `z` for `UNIX`, which isn't active for `mingw-w64-x86_64-cmake`.
mv lib/libzlibstatic.a lib/libz.a

7z -mx0 a ../zlib-1.3.1.7z *
