#!/bin/sh

source ./0_append_distro_path.sh

# Extract vanilla sources.
untar_file gmp-6.1.2.tar
untar_file mpfr-3.1.5.tar
untar_file mpc-1.0.3.tar
untar_file isl-0.18.tar
extract_file mingw-w64-v5.0.2.zip
untar_file gcc-7.2.0.tar

patch -Z -d /c/temp/gcc/mpfr-3.1.5 -p1 < mpfr.patch

cd /c/temp/gcc

# Build mingw-w64.
mv mingw-w64-v5.0.2 src
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
mv gcc-7.2.0 src
mv gmp-6.1.2 src/gmp
mv mpfr-3.1.5 src/mpfr
mv mpc-1.0.3 src/mpc
mv isl-0.18 src/isl

# Prepare to build gcc - perform magic directory surgery.
cp -r dest/x86_64-w64-mingw32/lib dest/x86_64-w64-mingw32/lib64
cp -r dest/x86_64-w64-mingw32 dest/mingw
mkdir -p src/gcc/winsup/mingw
cp -r dest/x86_64-w64-mingw32/include src/gcc/winsup/mingw/include

# Configure.
mkdir build
cd build

../src/configure --enable-languages=c,c++ --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 \
--target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/dest --with-sysroot=/c/temp/gcc/dest \
--disable-libstdcxx-pch --disable-libstdcxx-verbose --disable-nls --disable-shared --disable-win32-registry \
--with-tune=haswell || fail_with gcc 1 - EPIC FAIL

# --enable-languages=c,c++        : I want C and C++ only.
# --build=x86_64-w64-mingw32      : I want a native compiler.
# --host=x86_64-w64-mingw32       : Ditto.
# --target=x86_64-w64-mingw32     : Ditto.
# --disable-multilib              : I want 64-bit only.
# --prefix=/c/temp/gcc/dest       : I want the compiler to be installed here.
# --with-sysroot=/c/temp/gcc/dest : Ditto. (This one is important!)
# --disable-libstdcxx-pch         : I don't use this, and it takes up a ton of space.
# --disable-libstdcxx-verbose     : Reduce generated executable size. This doesn't affect the ABI.
# --disable-nls                   : I don't want Native Language Support.
# --disable-shared                : I don't want DLLs.
# --disable-win32-registry        : I don't want this abomination.
# --with-tune=haswell             : Tune for Haswell by default.

# Build and install.
make $X_MAKE_JOBS bootstrap "CFLAGS=-g0 -O3" "CXXFLAGS=-g0 -O3" "CFLAGS_FOR_TARGET=-g0 -O3" \
"CXXFLAGS_FOR_TARGET=-g0 -O3" "BOOT_CFLAGS=-g0 -O3" "BOOT_CXXFLAGS=-g0 -O3" || fail_with gcc 2 - EPIC FAIL

make install || fail_with gcc 3 - EPIC FAIL

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
