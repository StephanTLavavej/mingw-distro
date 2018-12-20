#!/bin/sh

source ./0_append_distro_path.sh

# Extract vanilla sources.
untar_file gmp-6.1.2.tar
untar_file mpfr-4.0.1.tar
untar_file mpc-1.1.0.tar
untar_file isl-0.20.tar
untar_file mingw-w64-v6.0.0.tar
untar_file gcc-8.2.0.tar

# Fixed upstream: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=86724
patch -d /c/temp/gcc/gcc-8.2.0 -p1 < gcc-bug-86724.patch

patch -Z -d /c/temp/gcc/mpfr-4.0.1 -p1 < mpfr-4.0.1-p13.patch

cd /c/temp/gcc

# Build mingw-w64 and winpthreads.
mv mingw-w64-v6.0.0 src
mkdir build-mingw-w64 dest
cd build-mingw-w64

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-lib32 \
--prefix=/c/temp/gcc/dest/x86_64-w64-mingw32 --with-sysroot=/c/temp/gcc/dest/x86_64-w64-mingw32 --enable-wildcard \
--with-libraries=winpthreads --disable-shared

# https://github.com/StephanTLavavej/mingw-distro/issues/64
cd mingw-w64-headers
make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc/build-mingw-w64

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make $X_MAKE_JOBS install
cd /c/temp/gcc

rm -rf build-mingw-w64 src

# Prepare to build gcc.
mv gcc-8.2.0 src
mv gmp-6.1.2 src/gmp
mv mpfr-4.0.1 src/mpfr
mv mpc-1.1.0 src/mpc
mv isl-0.20 src/isl

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
--with-tune=haswell --enable-threads=posix --enable-libgomp

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
# --enable-threads=posix          : Use winpthreads.
# --enable-libgomp                : Enable OpenMP.

# Build and install.
make $X_MAKE_JOBS bootstrap "CFLAGS=-g0 -O3" "CXXFLAGS=-g0 -O3" "CFLAGS_FOR_TARGET=-g0 -O3" \
"CXXFLAGS_FOR_TARGET=-g0 -O3" "BOOT_CFLAGS=-g0 -O3" "BOOT_CXXFLAGS=-g0 -O3"

make $X_MAKE_JOBS install

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
