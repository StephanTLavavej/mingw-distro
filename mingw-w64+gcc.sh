#!/bin/sh

source 0_append_distro_path.sh

# Extract vanilla sources.
7z x '-oC:\Temp\gcc' mingw-w64-v3.2.0.tar > NUL || fail_with mingw-w64-v3.2.0.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gcc-4.9.1.tar > NUL || fail_with gcc-4.9.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gmp-6.0.0a.tar > NUL || fail_with gmp-6.0.0a.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpfr-3.1.2.tar > NUL || fail_with mpfr-3.1.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpc-1.0.2.tar > NUL || fail_with mpc-1.0.2.tar - EPIC FAIL

patch -Z -d /c/temp/gcc/mpfr-3.1.2 -p1 < mpfr.patch

cd /c/temp/gcc

# mingw-w64 emits this cruft.
rm pax_global_header

# Build mingw-w64.
mv mingw-w64-v3.2.0 src
mkdir build dest
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-lib32 --prefix=/c/temp/gcc/dest/x86_64-w64-mingw32 --with-sysroot=/c/temp/gcc/dest/x86_64-w64-mingw32 --enable-wildcard || fail_with mingw-w64 configure - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with mingw-w64 make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

# Prepare to build gcc - set up the in-tree builds of gmp, mpfr, and mpc.
mv gcc-4.9.1 src
mv gmp-6.0.0 src/gmp
mv mpfr-3.1.2 src/mpfr
mv mpc-1.0.2 src/mpc

# Prepare to build gcc - perform magic directory surgery.
cp -r dest/x86_64-w64-mingw32/lib dest/x86_64-w64-mingw32/lib64
cp -r dest/x86_64-w64-mingw32 dest/mingw
mkdir -p src/gcc/winsup/mingw
cp -r dest/x86_64-w64-mingw32/include src/gcc/winsup/mingw/include

# Configure.
mkdir build
cd build
../src/configure --enable-languages=c,c++ --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest --disable-libstdcxx-pch --disable-lto --disable-nls --disable-shared --disable-win32-registry --enable-checking=release --with-tune=haswell || fail_with gcc configure - EPIC FAIL

# --enable-languages=c,c++        : I want C and C++ only.
# --build=x86_64-w64-mingw32      : I want a native compiler.
# --host=x86_64-w64-mingw32       : Ditto.
# --target=x86_64-w64-mingw32     : Ditto.
# --disable-multilib              : I want 64-bit only.
# --prefix=/c/temp/gcc/dest       : I want the compiler to be installed here.
# --with-sysroot=/c/temp/gcc/dest : Ditto. (This one is important!)
# --disable-libstdcxx-pch         : I don't use this, and it takes up a ton of space.
# --disable-lto                   : http://sourceforge.net/p/mingw-w64/wiki2/LTO%20and%20GCC/
# --disable-nls                   : I don't want Native Language Support.
# --disable-shared                : I don't want DLLs.
# --disable-win32-registry        : I don't want this abomination.
# --enable-checking=release       : I don't want expensive checking if this came from SVN or a snapshot.
# --with-tune=haswell             : Tune for Haswell by default.

# Build and install.
make bootstrap install "CFLAGS=-g0 -O3" "CXXFLAGS=-g0 -O3 -std=gnu++11" "CFLAGS_FOR_TARGET=-g0 -O3" "CXXFLAGS_FOR_TARGET=-g0 -O3 -std=gnu++11" "BOOT_CFLAGS=-g0 -O3" "BOOT_CXXFLAGS=-g0 -O3 -std=gnu++11" || fail_with gcc make - EPIC FAIL

# Cleanup.
cd /c/temp/gcc
rm -rf build src
mv dest mingw-w64+gcc
cd mingw-w64+gcc
find -name "*.la" -type f -print -exec rm {} ";"
rm -rf bin/c++.exe bin/x86_64-w64-mingw32-* share
rm -rf mingw x86_64-w64-mingw32/lib64
find -name "*.exe" -type f -print -exec strip -s {} ";"

7z -mx0 a ../mingw-w64+gcc.7z *
