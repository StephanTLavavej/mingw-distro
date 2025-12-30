#!/bin/sh

source ./0_append_distro_path.sh

# Work around https://github.com/msys2/MSYS2-packages/issues/1216 by excluding the directory
# that contains the affected symlink. We don't need it, as ZSTD_BUILD_TESTS defaults to OFF.
untar_file zstd-1.5.7.tar --exclude=zstd-1.5.7/tests

cd $X_WORK_DIR
mv zstd-1.5.7 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DZSTD_BUILD_SHARED=OFF" \
-G Ninja $X_WORK_DIR/src/build/cmake

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest zstd-1.5.7
cd zstd-1.5.7
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../zstd-1.5.7.7z *
