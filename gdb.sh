#!/bin/sh

source ./0_append_distro_path.sh

untar_file gdb-8.0.tar

cd /c/temp/gcc
mv gdb-8.0 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls || fail_with gdb 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s" || fail_with gdb 2 - EPIC FAIL
make install || fail_with gdb 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest gdb-8.0
cd gdb-8.0
rm -rf include lib share

7z -mx0 a ../gdb-8.0.7z *
