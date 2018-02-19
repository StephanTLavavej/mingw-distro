#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjpeg-turbo-1.5.3.tar

cd /c/temp/gcc
mv libjpeg-turbo-1.5.3 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest "CFLAGS=-s -O3 -DTWO_FILE_COMMANDLINE"

make $X_MAKE_JOBS
make install
cd /c/temp/gcc
rm -rf build src
mv dest libjpeg-turbo-1.5.3
cd libjpeg-turbo-1.5.3
rm -rf bin/cjpeg.exe bin/djpeg.exe bin/rdjpgcom.exe bin/tjbench.exe bin/wrjpgcom.exe lib/*.la lib/pkgconfig share

7z -mx0 a ../libjpeg-turbo-1.5.3.7z *
