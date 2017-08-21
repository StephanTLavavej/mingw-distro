#!/bin/sh

source ./0_append_distro_path.sh

untar_file lame-3.99.5.tar

cd /c/temp/gcc
mkdir -p dest/bin

mv lame-3.99.5 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest || fail_with lame 1 - EPIC FAIL

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s" || fail_with lame 2 - EPIC FAIL
mv frontend/lame.exe ../dest/bin || fail_with lame 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest lame-3.99.5
cd lame-3.99.5

7z -mx0 a ../lame-3.99.5.7z *
