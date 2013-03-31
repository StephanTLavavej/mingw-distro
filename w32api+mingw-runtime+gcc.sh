#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

# Extract vanilla sources.
7za x '-oC:\Temp\gcc' w32api-3.17-2-mingw32-src.tar > NUL || { echo w32api-3.17-2-mingw32-src.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' mingwrt-3.20-2-mingw32-src.tar > NUL || { echo mingwrt-3.20-2-mingw32-src.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' gcc-4.7.2.tar > NUL || { echo gcc-4.7.2.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' gmp-5.0.5.tar > NUL || { echo gmp-5.0.5.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' mpfr-3.1.1.tar > NUL || { echo mpfr-3.1.1.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' mpc-1.0.1.tar > NUL || { echo mpc-1.0.1.tar - EPIC FAIL ; exit 1; }

patch -Z -d /c/temp/gcc/mpfr-3.1.1 -p1 < mpfr.patch

# Change the default mode to C++11.
patch -d /c/temp/gcc/gcc-4.7.2 -p1 < gcc.patch

# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52538
# http://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=76d340ac07ad50937aa1ecbfdf0475b010a5700a
patch -d /c/temp/gcc/gcc-4.7.2 -p1 < gcc-pr52538.patch

cd /c/temp/gcc

# Build gmp.
mv gmp-5.0.5 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || { echo gmp configure - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || { echo gmp make - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest gmp

# Build mpfr.
mv mpfr-3.1.1 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp || { echo mpfr configure - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || { echo mpfr make - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpfr

# Build mpc.
mv mpc-1.0.1 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr || { echo mpc configure - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || { echo mpc make - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpc

# Build w32api.
mv w32api-3.17-2-mingw32 src
mkdir build dest
cd build
../src/configure --disable-nls --disable-shared --prefix=/c/temp/gcc/dest || { echo w32api configure - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || { echo w32api make - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest w32api

# Build mingw-runtime.
mv mingwrt-3.20-2-mingw32 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo mingw-runtime configure - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || { echo mingw-runtime make - EPIC FAIL ; exit 1; }
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
mv gcc-4.7.2 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr --with-mpc=/c/temp/gcc/mpc --enable-languages=c,c++ --with-arch=i686 --with-tune=generic --disable-libstdcxx-pch --disable-nls --disable-shared --disable-sjlj-exceptions --disable-win32-registry --enable-checking=release --enable-lto || { echo gcc configure - EPIC FAIL ; exit 1; }

# --disable-libstdcxx-pch   : I don't use this, and it takes up a ton of space.
# --disable-nls             : I don't want Native Language Support.
# --disable-shared          : I don't want DLLs.
# --disable-sjlj-exceptions : I don't want SJLJ, I want DW2.
# --disable-win32-registry  : I don't want this abomination.
# --enable-checking=release : I don't want expensive checking if this came from SVN or a snapshot.
# --enable-lto              : LTO is not enabled by default for MinGW, but can be explicitly requested.

# Build and install.
make bootstrap install "CFLAGS=-g0 -O3 -fomit-frame-pointer" "CXXFLAGS=-g0 -O3 -fomit-frame-pointer -mthreads" "CFLAGS_FOR_TARGET=-g0 -O3 -fomit-frame-pointer" "CXXFLAGS_FOR_TARGET=-g0 -O3 -fomit-frame-pointer -mthreads" "BOOT_CFLAGS=-g0 -O3 -fomit-frame-pointer" "BOOT_CXXFLAGS=-g0 -O3 -fomit-frame-pointer -mthreads" || { echo gcc make - EPIC FAIL ; exit 1; }

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
