#!/bin/sh

source ./0_append_distro_path.sh

untar_file sed-4.9.tar

cd $X_WORK_DIR
mkdir -p dest/bin

mv sed-4.9 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest

# -D_FORTIFY_SOURCE=0 works around https://github.com/StephanTLavavej/mingw-distro/issues/71
# -lbcrypt provides BCryptGenRandom
make $X_MAKE_JOBS "CFLAGS=-O3 -D_FORTIFY_SOURCE=0" "LDFLAGS=-s" "LIBS=-lbcrypt" sed/sed.exe

mv sed/sed.exe ../dest/bin
cd $X_WORK_DIR
rm -rf build src

mv dest sed-4.9
cd sed-4.9

7z -mx0 a ../sed-4.9.7z *
