#!/bin/sh

source ./0_append_distro_path.sh

untar_file sed-4.4.tar

cd /c/temp/gcc
mkdir -p dest/bin

mv sed-4.4 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest || fail_with sed 1 - EPIC FAIL

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s" || fail_with sed 2 - EPIC FAIL
mv sed/sed.exe ../dest/bin || fail_with sed 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest sed-4.4
cd sed-4.4

7z -mx0 a ../sed-4.4.7z *
