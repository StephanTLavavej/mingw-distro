#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' binutils-2.24.tar > NUL || fail_with binutils-2.24.tar - EPIC FAIL

# http://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=patch;h=0ef76c4
patch -d /c/temp/gcc/binutils-2.24 -p1 < binutils-0ef76c4.patch

# http://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=patch;h=27b829e
patch -d /c/temp/gcc/binutils-2.24 -p1 < binutils-27b829e.patch

cd /c/temp/gcc
mv binutils-2.24 src
mkdir build dest
cd build
../src/configure --disable-nls --disable-shared --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest || fail_with binutils - EPIC FAIL
make all install "CFLAGS=-O3" "LDFLAGS=-s" || fail_with binutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest binutils-2.24
cd binutils-2.24
rm -rf lib/*.la share

7z -mx0 a ../binutils-2.24.7z *
