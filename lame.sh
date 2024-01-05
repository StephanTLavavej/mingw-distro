#!/bin/sh

source ./0_append_distro_path.sh

untar_file lame-3.100.tar

cd $X_WORK_DIR
mkdir -p dest/bin

mv lame-3.100 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=$X_WORK_DIR/dest

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s"
mv frontend/lame.exe ../dest/bin
cd $X_WORK_DIR
rm -rf build src

mv dest lame-3.100
cd lame-3.100

7z -mx0 a ../lame-3.100.7z *
