#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjpeg-turbo-2.0.1.tar

cd /c/temp/gcc
mv libjpeg-turbo-2.0.1 src
mkdir build dest
cd build

cmake \
"-DCMAKE_ASM_NASM_FLAGS=-DWIN64" \
"-DCMAKE_ASM_NASM_OBJECT_FORMAT=win64" \
"-DCMAKE_C_FLAGS=-s -O3 -DTWO_FILE_COMMANDLINE" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DENABLE_SHARED=OFF" \
-G "Unix Makefiles" /c/temp/gcc/src

make $X_MAKE_JOBS
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src
mv dest libjpeg-turbo-2.0.1
cd libjpeg-turbo-2.0.1
rm -rf bin/cjpeg.exe bin/djpeg.exe bin/rdjpgcom.exe bin/tjbench.exe bin/wrjpgcom.exe lib/pkgconfig share

7z -mx0 a ../libjpeg-turbo-2.0.1.7z *
