#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' pcre-8.32.tar > NUL || fail_with pcre-8.32.tar - EPIC FAIL

patch -d /c/temp/gcc/pcre-8.32 -p1 < pcre.patch

cd /c/temp/gcc
mv pcre-8.32 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared "CFLAGS=-s -O3 -fomit-frame-pointer" "CXXFLAGS=-s -O3 -fomit-frame-pointer" || fail_with pcre - EPIC FAIL
make all install || fail_with pcre - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest pcre-8.32
cd pcre-8.32
rm -rf bin lib/pkgconfig lib/*.la share
cp include/pcreposix.h include/regex.h

7za -mx0 a ../pcre-8.32.7z *
