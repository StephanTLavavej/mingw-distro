#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' zlib-1.2.8.tar > NUL || fail_with zlib-1.2.8.tar - EPIC FAIL

patch -d /c/temp/gcc/zlib-1.2.8 -p1 < zlib.patch

cd /c/temp/gcc
mv zlib-1.2.8 src
mkdir -p dest/include dest/lib
cd src
gcc -s -O3 -fomit-frame-pointer -c *.c || fail_with zlib - EPIC FAIL
ar rs ../dest/lib/libz.a *.o
mv zconf.h zlib.h ../dest/include
cd /c/temp/gcc
rm -rf src
mv dest zlib-1.2.8
cd zlib-1.2.8

7za -mx0 a ../zlib-1.2.8.7z *
