#!/bin/sh

source 0_append_distro_path.sh

# Extract vanilla sources.
7za x '-oC:\Temp\gcc' w32api-3.17-2-mingw32-src.tar > NUL || fail_with w32api-3.17-2-mingw32-src.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' mingwrt-3.20-2-mingw32-src.tar > NUL || fail_with mingwrt-3.20-2-mingw32-src.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' gcc-4.8.1.tar > NUL || fail_with gcc-4.8.1.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' gmp-5.1.2.tar > NUL || fail_with gmp-5.1.2.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' mpfr-3.1.2.tar > NUL || fail_with mpfr-3.1.2.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' mpc-1.0.1.tar > NUL || fail_with mpc-1.0.1.tar - EPIC FAIL

# patch -Z -d /c/temp/gcc/mpfr-3.1.2 -p1 < mpfr.patch

# Change the default mode to C++11.
patch -d /c/temp/gcc/gcc-4.8.1 -p1 < gcc.patch

cd /c/temp/gcc

# Build gmp.
mv gmp-5.1.2 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with gmp configure - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with gmp make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest gmp

# Build mpfr.
mv mpfr-3.1.2 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp || fail_with mpfr configure - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with mpfr make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpfr

# Build mpc.
mv mpc-1.0.1 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr || fail_with mpc configure - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with mpc make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpc

# Build w32api.
mv w32api-3.17-2-mingw32 src
mkdir build dest
cd build
../src/configure --disable-nls --disable-shared --prefix=/c/temp/gcc/dest || fail_with w32api configure - EPIC FAIL
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with w32api make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest w32api

# Build mingw-runtime.
mv mingwrt-3.20-2-mingw32 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with mingw-runtime configure - EPIC FAIL
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with mingw-runtime make - EPIC FAIL
cd /c/temp/gcc
rm -rf build src dest/doc dest/share
rm -rf dest/bin # http://article.gmane.org/gmane.comp.gnu.mingw.user/36739
mv dest mingw-runtime

# Copy w32api and mingw-runtime.
rm -rf /mingw
mkdir /mingw
cp -r w32api/* /mingw
cp -r mingw-runtime/* /mingw

# Configure.
mv gcc-4.8.1 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr --with-mpc=/c/temp/gcc/mpc --enable-languages=c,c++ --with-arch=i686 --with-tune=generic --disable-libstdcxx-pch --disable-nls --disable-shared --disable-sjlj-exceptions --disable-win32-registry --enable-checking=release --enable-lto || fail_with gcc configure - EPIC FAIL

# --disable-libstdcxx-pch   : I don't use this, and it takes up a ton of space.
# --disable-nls             : I don't want Native Language Support.
# --disable-shared          : I don't want DLLs.
# --disable-sjlj-exceptions : I don't want SJLJ, I want DW2.
# --disable-win32-registry  : I don't want this abomination.
# --enable-checking=release : I don't want expensive checking if this came from SVN or a snapshot.
# --enable-lto              : LTO is not enabled by default for MinGW, but can be explicitly requested.

# Build and install.
make bootstrap install "CFLAGS=-g0 -O3 -fomit-frame-pointer" "CXXFLAGS=-g0 -O3 -fomit-frame-pointer -mthreads" "CFLAGS_FOR_TARGET=-g0 -O3 -fomit-frame-pointer" "CXXFLAGS_FOR_TARGET=-g0 -O3 -fomit-frame-pointer -mthreads" "BOOT_CFLAGS=-g0 -O3 -fomit-frame-pointer" "BOOT_CXXFLAGS=-g0 -O3 -fomit-frame-pointer -mthreads" || fail_with gcc make - EPIC FAIL

# Cleanup.
rm -rf /mingw
cd /c/temp/gcc
rm -rf build src
cp -r w32api/* dest
cp -r mingw-runtime/* dest
rm -rf w32api mingw-runtime gmp mpfr mpc
mv dest w32api+mingw-runtime+gcc
cd w32api+mingw-runtime+gcc
rm -rf share
find -name "*.la" -type f -print -exec rm {} ";"
cd bin
rm c++.exe i686-pc-mingw32-*
cp gcc.exe cc.exe
cd ..
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../w32api+mingw-runtime+gcc.7z *
