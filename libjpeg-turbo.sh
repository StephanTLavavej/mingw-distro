#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' libjpeg-turbo-1.4.2.tar > /dev/null || fail_with libjpeg-turbo-1.4.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' cmake-3.3.2-win32-x86.zip > /dev/null || fail_with cmake-3.3.2-win32-x86.zip - EPIC FAIL
7z x '-oC:\Temp\gcc' nasm-2.11.08-win32.zip > /dev/null || fail_with nasm-2.11.08-win32.zip - EPIC FAIL

cd /c/temp/gcc
mv cmake-3.3.2-win32-x86 cmake
mv nasm-2.11.08 nasm
export PATH=$PATH:/c/temp/gcc/cmake/bin:/c/temp/gcc/nasm
mv libjpeg-turbo-1.4.2 src
mkdir -p build dest/bin dest/include dest/lib
cd build
cmake -G "MSYS Makefiles" "-DCMAKE_C_FLAGS=-s -O3 -DTWO_FILE_COMMANDLINE -Wno-attributes" /c/temp/gcc/src || fail_with libjpeg-turbo - EPIC FAIL
# make install must NOT be used, as it will contaminate the Windows system directory.
make || fail_with libjpeg-turbo - EPIC FAIL
cd /c/temp/gcc
mv build/jpegtran-static.exe dest/bin/jpegtran.exe || fail_with libjpeg-turbo - EPIC FAIL
mv build/jconfig.h src/jerror.h src/jmorecfg.h src/jpeglib.h src/turbojpeg.h dest/include || fail_with libjpeg-turbo - EPIC FAIL
mv build/libjpeg.a build/libturbojpeg.a dest/lib || fail_with libjpeg-turbo - EPIC FAIL
rm -rf build src cmake nasm
mv dest libjpeg-turbo-1.4.2
cd libjpeg-turbo-1.4.2

7z -mx0 a ../libjpeg-turbo-1.4.2.7z *
