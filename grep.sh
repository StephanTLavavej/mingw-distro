#!/bin/sh

source ./0_append_distro_path.sh

extract_file grep-2.10.tar

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls --disable-largefile "CFLAGS=-s -O3 -DPCRE_STATIC" \
|| fail_with grep 1 - EPIC FAIL

make $X_MAKE_JOBS || fail_with grep 2 - EPIC FAIL
mv src/grep.exe ../dest/bin || fail_with grep 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest grep-2.10
cd grep-2.10

7z -mx0 a ../grep-2.10.7z *
