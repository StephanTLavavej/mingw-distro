#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' libjpeg-turbo-1.2.90.tar > NUL || fail_with libjpeg-turbo-1.2.90.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' cmake-2.8.10.2-win32-x86.zip > NUL || fail_with cmake-2.8.10.2-win32-x86.zip - EPIC FAIL
7za x '-oC:\Temp\gcc' nasm-2.10.07-win32.zip > NUL || fail_with nasm-2.10.07-win32.zip - EPIC FAIL

cd /c/temp/gcc
mv cmake-2.8.10.2-win32-x86 cmake
mv nasm-2.10.07 nasm
export PATH=$PATH:/c/temp/gcc/cmake/bin:/c/temp/gcc/nasm
mv libjpeg-turbo-1.2.90 src
mkdir -p build dest/bin dest/include dest/lib
cd build
cmake -G "MSYS Makefiles" "-DCMAKE_C_FLAGS=-s -O3 -fomit-frame-pointer -DTWO_FILE_COMMANDLINE -Wno-attributes" /c/temp/gcc/src || fail_with libjpeg-turbo - EPIC FAIL
# make install must NOT be used, as it will contaminate the Windows system directory.
make || fail_with libjpeg-turbo - EPIC FAIL
cd /c/temp/gcc
mv build/jpegtran-static.exe dest/bin/jpegtran.exe || fail_with libjpeg-turbo - EPIC FAIL
mv build/jconfig.h src/jerror.h src/jmorecfg.h src/jpeglib.h src/turbojpeg.h dest/include || fail_with libjpeg-turbo - EPIC FAIL
mv build/libjpeg.a build/libturbojpeg.a dest/lib || fail_with libjpeg-turbo - EPIC FAIL
rm -rf build src cmake nasm
mv dest libjpeg-turbo-1.2.90
cd libjpeg-turbo-1.2.90
# Verified that strip is unnecessary.

7za -mx0 a ../libjpeg-turbo-1.2.90.7z *
