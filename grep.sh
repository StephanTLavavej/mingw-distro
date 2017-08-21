#!/bin/sh

source ./0_append_distro_path.sh

untar_file grep-3.1.tar

patch -d /c/temp/gcc/grep-3.1 -p1 < grep-configure.patch
patch -d /c/temp/gcc/grep-3.1 -p1 < grep-lock.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-3.1 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls "CFLAGS=-s -O3 -DPCRE_STATIC" \
|| fail_with grep 1 - EPIC FAIL

make $X_MAKE_JOBS || fail_with grep 2 - EPIC FAIL
mv src/grep.exe ../dest/bin || fail_with grep 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest grep-3.1
cd grep-3.1

7z -mx0 a ../grep-3.1.7z *
