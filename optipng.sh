#!/bin/sh

source ./0_append_distro_path.sh

untar_file optipng-7.9.1.tar

cd $X_WORK_DIR
mv optipng-7.9.1 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# Set OPTIPNG_USE_SYSTEM_LIBS to avoid picking up potentially older "vendored" versions.
# Set ZLIB_ROOT and PNG_ROOT to pick them up from the distro instead of /mingw64/bin.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DOPTIPNG_USE_SYSTEM_LIBS=ON" \
"-DZLIB_ROOT=$X_DISTRO_ROOT" \
"-DPNG_ROOT=$X_DISTRO_ROOT" \
-G Ninja $X_WORK_DIR/src

ninja
# Work around https://github.com/StephanTLavavej/mingw-distro/issues/112
mv optipng.exe optipng
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest optipng-7.9.1
cd optipng-7.9.1
rm -rf share
# Work around https://github.com/StephanTLavavej/mingw-distro/issues/112
mv bin/optipng bin/optipng.exe

7z -mx0 a ../optipng-7.9.1.7z *
