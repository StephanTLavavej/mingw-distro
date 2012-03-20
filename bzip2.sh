#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' bzip2-1.0.6.tar > NUL || { echo bzip2-1.0.6.tar - EPIC FAIL ; exit 1; }

cd /c/temp/gcc
mv bzip2-1.0.6 src
mkdir -p build dest/include dest/lib
cd src
cp blocksort.c bzlib.c compress.c crctable.c decompress.c huffman.c randtable.c bzlib.h bzlib_private.h ../build
cd ../build
gcc -s -Os -fomit-frame-pointer -c *.c || { echo bzip2 - EPIC FAIL ; exit 1; }
ar rs ../dest/lib/libbz2.a *.o
mv bzlib.h ../dest/include
cd /c/temp/gcc
rm -rf src build
mv dest bzip2-1.0.6
cd bzip2-1.0.6

7za -mx0 a ../bzip2-1.0.6.7z *
