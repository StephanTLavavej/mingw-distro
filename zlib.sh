#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' zlib-1.2.7.tar > NUL || { echo zlib-1.2.7.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/zlib-1.2.7 -p1 < zlib.patch

cd /c/temp/gcc
mv zlib-1.2.7 src
mkdir -p dest/include dest/lib
cd src
gcc -s -O3 -fomit-frame-pointer -c *.c || { echo zlib - EPIC FAIL ; exit 1; }
ar rs ../dest/lib/libz.a *.o
mv zconf.h zlib.h ../dest/include
cd /c/temp/gcc
rm -rf src
mv dest zlib-1.2.7
cd zlib-1.2.7

7za -mx0 a ../zlib-1.2.7.7z *
