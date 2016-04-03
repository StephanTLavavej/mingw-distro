#!/bin/sh

source ./0_append_distro_path.sh

# Extract vanilla sources.
7z x '-oC:\Temp\gcc' gmp-6.1.0.tar || fail_with gmp-6.1.0.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpfr-3.1.3.tar || fail_with mpfr-3.1.3.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpc-1.0.3.tar || fail_with mpc-1.0.3.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mingw-w64-v4.0.4.tar || fail_with mingw-w64-v4.0.4.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gcc-5.3.0.tar || fail_with gcc-5.3.0.tar - EPIC FAIL

patch -Z -d /c/temp/gcc/mpfr-3.1.3 -p1 < mpfr.patch

cd /c/temp/gcc

# mingw-w64 emits this cruft.
rm pax_global_header

# Build gmp.
mv gmp-6.1.0 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared || fail_with gmp 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with gmp 2 - EPIC FAIL
make install || fail_with gmp 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest gmp

# Build mpfr.
mv mpfr-3.1.3 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp || fail_with mpfr 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with mpfr 2 - EPIC FAIL
make install || fail_with mpfr 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpfr

# Build mpc.
mv mpc-1.0.3 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr \
|| fail_with mpc 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with mpc 2 - EPIC FAIL
make install || fail_with mpc 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
rm -rf dest/lib/*.la dest/share
mv dest mpc

# Build mingw-w64.
mv mingw-w64-v4.0.4 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-lib32 \
--prefix=/c/temp/gcc/dest/x86_64-w64-mingw32 --with-sysroot=/c/temp/gcc/dest/x86_64-w64-mingw32 --enable-wildcard \
|| fail_with mingw-w64 1 - EPIC FAIL

make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with mingw-w64 2 - EPIC FAIL
make install || fail_with mingw-w64 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

# Prepare to build gcc.
mv gcc-5.3.0 src

# Prepare to build gcc - perform magic directory surgery.
cp -r dest/x86_64-w64-mingw32/lib dest/x86_64-w64-mingw32/lib64
cp -r dest/x86_64-w64-mingw32 dest/mingw
mkdir -p src/gcc/winsup/mingw
cp -r dest/x86_64-w64-mingw32/include src/gcc/winsup/mingw/include

# Configure.
mkdir build
cd build

../src/configure --with-gmp=/c/temp/gcc/gmp --with-mpfr=/c/temp/gcc/mpfr --with-mpc=/c/temp/gcc/mpc \
--enable-languages=c,c++ --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest --disable-libstdcxx-pch --disable-nls \
--disable-shared --disable-win32-registry --enable-checking=release --with-tune=haswell || fail_with gcc 1 - EPIC FAIL

# --with-gmp=/c/temp/gcc/gmp      : Obvious.
# --with-mpfr=/c/temp/gcc/mpfr    : Obvious.
# --with-mpc=/c/temp/gcc/mpc      : Obvious.
# --enable-languages=c,c++        : I want C and C++ only.
# --build=x86_64-w64-mingw32      : I want a native compiler.
# --host=x86_64-w64-mingw32       : Ditto.
# --target=x86_64-w64-mingw32     : Ditto.
# --disable-multilib              : I want 64-bit only.
# --prefix=/c/temp/gcc/dest       : I want the compiler to be installed here.
# --with-sysroot=/c/temp/gcc/dest : Ditto. (This one is important!)
# --disable-libstdcxx-pch         : I don't use this, and it takes up a ton of space.
# --disable-nls                   : I don't want Native Language Support.
# --disable-shared                : I don't want DLLs.
# --disable-win32-registry        : I don't want this abomination.
# --enable-checking=release       : I don't want expensive checking if this came from SVN or a snapshot.
# --with-tune=haswell             : Tune for Haswell by default.

# Build and install.
make $X_MAKE_JOBS bootstrap "CFLAGS=-g0 -O3" "CXXFLAGS=-g0 -O3" "CFLAGS_FOR_TARGET=-g0 -O3" \
"CXXFLAGS_FOR_TARGET=-g0 -O3" "BOOT_CFLAGS=-g0 -O3" "BOOT_CXXFLAGS=-g0 -O3" || fail_with gcc 2 - EPIC FAIL

make install || fail_with gcc 3 - EPIC FAIL

# Cleanup.
cd /c/temp/gcc
rm -rf build src
rm -rf gmp mpfr mpc
mv dest mingw-w64+gcc
cd mingw-w64+gcc
find -name "*.la" -type f -print -exec rm {} ";"
rm -rf bin/c++.exe bin/x86_64-w64-mingw32-* share
rm -rf mingw x86_64-w64-mingw32/lib64
find -name "*.exe" -type f -print -exec strip -s {} ";"

7z -mx0 a ../mingw-w64+gcc.7z *
