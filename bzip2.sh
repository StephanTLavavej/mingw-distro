#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' bzip2-1.0.6.tar > NUL || fail_with bzip2-1.0.6.tar - EPIC FAIL

cd /c/temp/gcc
mv bzip2-1.0.6 src
mkdir -p build dest/include dest/lib
cd src
cp blocksort.c bzlib.c compress.c crctable.c decompress.c huffman.c randtable.c bzlib.h bzlib_private.h ../build
cd ../build
gcc -s -O3 -c *.c || fail_with bzip2 - EPIC FAIL
ar rs ../dest/lib/libbz2.a *.o
mv bzlib.h ../dest/include
cd /c/temp/gcc
rm -rf src build
mv dest bzip2-1.0.6
cd bzip2-1.0.6

7z -mx0 a ../bzip2-1.0.6.7z *
