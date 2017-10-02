#!/bin/sh

source ./0_append_distro_path.sh

untar_file libjpeg-turbo-1.5.2.tar

cd /c/temp/gcc
mv libjpeg-turbo-1.5.2 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest "CFLAGS=-s -O3 -DTWO_FILE_COMMANDLINE" || fail_with libjpeg-turbo 1 - EPIC FAIL

make $X_MAKE_JOBS || fail_with libjpeg-turbo 2 - EPIC FAIL
make install || fail_with libjpeg-turbo 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest libjpeg-turbo-1.5.2
cd libjpeg-turbo-1.5.2
rm -rf bin/cjpeg.exe bin/djpeg.exe bin/rdjpgcom.exe bin/tjbench.exe bin/wrjpgcom.exe lib/*.la lib/pkgconfig share

7z -mx0 a ../libjpeg-turbo-1.5.2.7z *
