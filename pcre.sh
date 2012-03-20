#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' pcre-8.30.tar > NUL || { echo pcre-8.30.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/pcre-8.30 -p1 < pcre.patch

cd /c/temp/gcc
mv pcre-8.30 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared "CFLAGS=-s -Os -fomit-frame-pointer" "CXXFLAGS=-s -Os -fomit-frame-pointer" || { echo pcre - EPIC FAIL ; exit 1; }
make all install || { echo pcre - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest pcre-8.30
cd pcre-8.30
rm -rf bin lib/pkgconfig lib/*.la share
cp include/pcreposix.h include/regex.h

7za -mx0 a ../pcre-8.30.7z *
