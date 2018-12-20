#!/bin/sh

source ./0_append_distro_path.sh

untar_file binutils-2.30.tar

# https://github.com/StephanTLavavej/mingw-distro/issues/51
# Fixed upstream: https://sourceware.org/bugzilla/show_bug.cgi?id=22762
patch -d /c/temp/gcc/binutils-2.30 -p1 < binutils-bug-22762.patch

cd /c/temp/gcc
mv binutils-2.30 src
mkdir build dest
cd build

../src/configure --disable-nls --disable-shared --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 \
--target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src
mv dest binutils-2.30
cd binutils-2.30
rm -rf lib/*.la share

7z -mx0 a ../binutils-2.30.7z *
