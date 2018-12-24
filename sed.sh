#!/bin/sh

source ./0_append_distro_path.sh

untar_file sed-4.7.tar

cd /c/temp/gcc
mkdir -p dest/bin

mv sed-4.7 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s" sed/sed.exe
mv sed/sed.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv dest sed-4.7
cd sed-4.7

7z -mx0 a ../sed-4.7.7z *
