#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' gdb-7.10.tar > NUL || fail_with gdb-7.10.tar - EPIC FAIL

cd /c/temp/gcc
mv gdb-7.10 src
mkdir build dest
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-nls || fail_with gdb - EPIC FAIL
make all install "CFLAGS=-O3" "LDFLAGS=-s" || fail_with gdb - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest gdb-7.10
cd gdb-7.10
rm -rf include lib share

7z -mx0 a ../gdb-7.10.7z *
