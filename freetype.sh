#!/bin/sh

source ./0_append_distro_path.sh

untar_file freetype-2.13.2.tar

# https://github.com/StephanTLavavej/mingw-distro/issues/97
patch -d $X_WORK_DIR/freetype-2.13.2 -p1 < freetype-fix-cmake-mingw.patch

cd $X_WORK_DIR
mv freetype-2.13.2 src
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
mv dest freetype-2.13.2
cd freetype-2.13.2
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../freetype-2.13.2.7z *
