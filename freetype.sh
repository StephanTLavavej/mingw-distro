#!/bin/sh

source ./0_append_distro_path.sh

untar_file freetype-2.14.1.tar

cd $X_WORK_DIR
mv freetype-2.14.1 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# Set FT_DISABLE_BROTLI, FT_DISABLE_BZIP2, and FT_DISABLE_HARFBUZZ to avoid picking them up from /mingw64/bin.
# Set ZLIB_ROOT and PNG_ROOT to pick them up from the distro instead of /mingw64/bin.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DFT_DISABLE_BROTLI=ON" \
"-DFT_DISABLE_BZIP2=ON" \
"-DFT_DISABLE_HARFBUZZ=ON" \
"-DZLIB_ROOT=$X_DISTRO_ROOT" \
"-DPNG_ROOT=$X_DISTRO_ROOT" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest freetype-2.14.1
cd freetype-2.14.1
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../freetype-2.14.1.7z *
