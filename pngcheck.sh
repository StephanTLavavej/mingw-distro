#!/bin/sh

source ./0_append_distro_path.sh

untar_file pngcheck-4.0.1.tar

cd $X_WORK_DIR
mv pngcheck-4.0.1 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# Set ZLIB_ROOT to pick it up from the distro instead of /mingw64/bin.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DZLIB_ROOT=$X_DISTRO_ROOT" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest pngcheck-4.0.1
cd pngcheck-4.0.1
rm -rf share

7z -mx0 a ../pngcheck-4.0.1.7z *
