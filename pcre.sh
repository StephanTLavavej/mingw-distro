#!/bin/sh

source ./0_append_distro_path.sh

7z x '-oC:\Temp\gcc' pcre-8.37.tar > /dev/null || fail_with pcre-8.37.tar - EPIC FAIL

patch -d /c/temp/gcc/pcre-8.37 -p1 < pcre.patch
patch -d /c/temp/gcc/pcre-8.37 -p1 < pcre-color.patch

cd /c/temp/gcc
mv pcre-8.37 src
mkdir build dest
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared \
--enable-utf --enable-unicode-properties --enable-pcre16 --enable-pcre32 \
"CFLAGS=-s -O3" "CXXFLAGS=-s -O3" || fail_with pcre - EPIC FAIL
make all install || fail_with pcre - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest pcre-8.37
cd pcre-8.37
rm -rf bin/pcre-config lib/pkgconfig lib/*.la share
cp include/pcreposix.h include/regex.h

7z -mx0 a ../pcre-8.37.7z *
