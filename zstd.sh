#!/bin/sh

source ./0_append_distro_path.sh

untar_file zstd-1.5.0.tar

cd $X_WORK_DIR
mv zstd-1.5.0 src
mkdir build dest
cd build

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
mv dest zstd-1.5.0
cd zstd-1.5.0
rm -rf bin/zstdgrep bin/zstdless lib/cmake lib/pkgconfig share
for i in bin/unzstd bin/zstdcat bin/zstdmt; do mv $i $i.exe; done

7z -mx0 a ../zstd-1.5.0.7z *
