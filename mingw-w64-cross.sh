#!/bin/sh

# http://sourceforge.net/apps/trac/mingw-w64/wiki/Cross%20Win32%20and%20Win64%20compiler

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' binutils-2.23.2.tar > NUL || fail_with binutils-2.23.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gcc-4.8.1.tar > NUL || fail_with gcc-4.8.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gmp-5.1.2.tar > NUL || fail_with gmp-5.1.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mingw-w64-code-5986-trunk.zip > NUL || fail_with mingw-w64-code-5986-trunk.zip - EPIC FAIL
7z x '-oC:\Temp\gcc' mpc-1.0.1.tar > NUL || fail_with mpc-1.0.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpfr-3.1.2.tar > NUL || fail_with mpfr-3.1.2.tar - EPIC FAIL

patch -d /c/temp/gcc/binutils-2.23.2 -p1 < binutils.patch

cd /c/temp/gcc
mv binutils-2.23.2 src
mkdir build cross
cd build
../src/configure --disable-nls --disable-shared --target=x86_64-w64-mingw32 --disable-multilib --with-sysroot=/c/temp/gcc/cross --prefix=/c/temp/gcc/cross || fail_with binutils - EPIC FAIL
make all install || fail_with binutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

export PATH=$PATH:/c/temp/gcc/cross/bin

mkdir build
cd build
../mingw-w64-code-5986-trunk/mingw-w64-headers/configure --build=i686-pc-mingw32 --host=x86_64-w64-mingw32 --prefix=/c/temp/gcc/cross/x86_64-w64-mingw32 || fail_with EPIC FAIL
make install || fail_with EPIC FAIL
cp -r /c/temp/gcc/cross/x86_64-w64-mingw32/lib /c/temp/gcc/cross/x86_64-w64-mingw32/lib64
cp -r /c/temp/gcc/cross/x86_64-w64-mingw32 /c/temp/gcc/cross/mingw
cd /c/temp/gcc
rm -rf build

mv gmp-5.1.2 gcc-4.8.1/gmp
mv mpfr-3.1.2 gcc-4.8.1/mpfr
mv mpc-1.0.1 gcc-4.8.1/mpc

mkdir build
cd build
../gcc-4.8.1/configure --enable-languages=c,c++ --disable-libstdcxx-pch --disable-nls --disable-shared --disable-win32-registry --target=x86_64-w64-mingw32 --disable-multilib --with-sysroot=/c/temp/gcc/cross --prefix=/c/temp/gcc/cross || fail_with gcc configure - EPIC FAIL
make all-gcc || fail_with EPIC FAIL
make install-gcc || fail_with EPIC FAIL

cd /c/temp/gcc
mkdir build_crt
cd build_crt
../mingw-w64-code-5986-trunk/configure --host=x86_64-w64-mingw32 --disable-lib32 --with-sysroot=/c/temp/gcc/cross/x86_64-w64-mingw32 --prefix=/c/temp/gcc/cross/x86_64-w64-mingw32 || fail_with EPIC FAIL
make || fail_with EPIC FAIL
make install || fail_with EPIC FAIL
cd /c/temp/gcc
cp -r cross/x86_64-w64-mingw32/lib/* cross/x86_64-w64-mingw32/lib64
cp -r cross/x86_64-w64-mingw32/* cross/mingw
rm -rf build_crt mingw-w64-code-5986-trunk

cd build
make || fail_with EPIC FAIL
make install || fail_with EPIC FAIL
cd /c/temp/gcc
rm -rf build gcc-4.8.1
