#!/bin/sh

# http://sourceforge.net/apps/trac/mingw-w64/wiki/Native%20Win64%20compiler

export PATH=$PATH:/c/temp/gcc/cross/bin

function fail_with {
    echo $*
    if [ "$PS1" == "" ]; then exit 1; fi
}

7z x '-oC:\Temp\gcc' binutils-2.23.2.tar > NUL || fail_with binutils-2.23.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gcc-4.8.1.tar > NUL || fail_with gcc-4.8.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' gmp-5.1.2.tar > NUL || fail_with gmp-5.1.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mingw-w64-code-5986-trunk.zip > NUL || fail_with mingw-w64-code-5986-trunk.zip - EPIC FAIL
7z x '-oC:\Temp\gcc' mpc-1.0.1.tar > NUL || fail_with mpc-1.0.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' mpfr-3.1.2.tar > NUL || fail_with mpfr-3.1.2.tar - EPIC FAIL

patch -d /c/temp/gcc/binutils-2.23.2 -p1 < binutils.patch

cd /c/temp/gcc
mv binutils-2.23.2 src
mkdir build native
cd build
../src/configure --disable-nls --disable-shared --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/native --with-sysroot=/c/temp/gcc/native || fail_with binutils - EPIC FAIL
make all install || fail_with binutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mkdir build
cd build
../mingw-w64-code-5986-trunk/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-lib32 --prefix=/c/temp/gcc/native/x86_64-w64-mingw32 --with-sysroot=/c/temp/gcc/native/x86_64-w64-mingw32 || fail_with EPIC FAIL
make all install || fail_with EPIC FAIL
cd /c/temp/gcc
cp -r native/x86_64-w64-mingw32/lib native/x86_64-w64-mingw32/lib64
cp -r native/x86_64-w64-mingw32 native/mingw
mkdir -p gcc-4.8.1/gcc/winsup/mingw
cp -r native/x86_64-w64-mingw32/include gcc-4.8.1/gcc/winsup/mingw/include
rm -rf build mingw-w64-code-5986-trunk

mv gmp-5.1.2 gcc-4.8.1/gmp
mv mpfr-3.1.2 gcc-4.8.1/mpfr
mv mpc-1.0.1 gcc-4.8.1/mpc

mkdir build
cd build
../gcc-4.8.1/configure --enable-languages=c,c++ --disable-libstdcxx-pch --disable-nls --disable-shared --disable-win32-registry --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-multilib --prefix=/c/temp/gcc/native --with-sysroot=/c/temp/gcc/native || fail_with gcc configure - EPIC FAIL
make bootstrap install || fail_with gcc make - EPIC FAIL
cd /c/temp/gcc
rm -rf build gcc-4.8.1
