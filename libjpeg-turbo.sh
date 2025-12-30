#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjpeg-turbo-3.1.3.tar

cd $X_WORK_DIR
mv libjpeg-turbo-3.1.3 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
# Compile with `-Wno-stringop-overflow` to silence false positives. See:
# https://github.com/libjpeg-turbo/libjpeg-turbo/issues/722
# https://github.com/libjpeg-turbo/libjpeg-turbo/issues/796
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3 -DTWO_FILE_COMMANDLINE -Wno-stringop-overflow" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DENABLE_SHARED=OFF" \
"-DWITH_TESTS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest libjpeg-turbo-3.1.3
cd libjpeg-turbo-3.1.3
rm -rf bin/cjpeg.exe bin/djpeg.exe bin/rdjpgcom.exe bin/tjbench.exe bin/wrjpgcom.exe lib/cmake lib/pkgconfig share

7z -mx0 a ../libjpeg-turbo-3.1.3.7z *
