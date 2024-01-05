#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjpeg-turbo-2.1.1.tar

cd $X_WORK_DIR
mv libjpeg-turbo-2.1.1 src
mkdir build dest
cd build

cmake \
"-DCMAKE_ASM_NASM_FLAGS=-DWIN64" \
"-DCMAKE_ASM_NASM_OBJECT_FORMAT=win64" \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3 -DTWO_FILE_COMMANDLINE" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DENABLE_SHARED=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest libjpeg-turbo-2.1.1
cd libjpeg-turbo-2.1.1
rm -rf bin/cjpeg.exe bin/djpeg.exe bin/rdjpgcom.exe bin/tjbench.exe bin/wrjpgcom.exe lib/cmake lib/pkgconfig share

7z -mx0 a ../libjpeg-turbo-2.1.1.7z *
