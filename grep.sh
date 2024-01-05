#!/bin/sh

source ./0_append_distro_path.sh

untar_file grep-3.7.tar

cd $X_WORK_DIR
mkdir -p dest/bin

mv grep-3.7 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest --disable-nls "CFLAGS=-s -O3 -DPCRE_STATIC"

make $X_MAKE_JOBS
mv src/grep.exe ../dest/bin
cd $X_WORK_DIR
rm -rf build src

mv dest grep-3.7
cd grep-3.7

7z -mx0 a ../grep-3.7.7z *
