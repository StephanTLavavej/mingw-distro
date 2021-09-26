#!/bin/sh

source ./0_append_distro_path.sh

untar_file zstd-1.5.0.tar

cd /c/temp/gcc
mv zstd-1.5.0 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DZSTD_BUILD_SHARED=OFF" \
-G Ninja /c/temp/gcc/src/build/cmake

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest zstd-1.5.0
cd zstd-1.5.0
rm -rf bin/zstdgrep bin/zstdless lib/cmake lib/pkgconfig share
for i in bin/unzstd bin/zstdcat bin/zstdmt; do mv $i $i.exe; done

7z -mx0 a ../zstd-1.5.0.7z *
