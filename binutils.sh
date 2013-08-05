#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' binutils-2.23.2.tar > NUL || fail_with binutils-2.23.2.tar - EPIC FAIL

patch -d /c/temp/gcc/binutils-2.23.2 -p1 < binutils.patch

cd /c/temp/gcc
mv binutils-2.23.2 src
mkdir build dest
cd build
../src/configure --disable-nls --disable-shared --prefix=/c/temp/gcc/dest || fail_with binutils - EPIC FAIL
make all install "CFLAGS=-O3" "LDFLAGS=-s" || fail_with binutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest binutils-2.23.2
cd binutils-2.23.2
rm -rf lib/*.la share

7z -mx0 a ../binutils-2.23.2.7z *
