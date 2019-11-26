#!/bin/sh

source ./0_append_distro_path.sh

untar_file gdb-8.3.1.tar

cd /c/temp/gcc
mv gdb-8.3.1 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls

# -D_FORTIFY_SOURCE=0 works around https://github.com/StephanTLavavej/mingw-distro/issues/71
make $X_MAKE_JOBS all "CFLAGS=-O3 -D_FORTIFY_SOURCE=0" "CXXFLAGS=-O3 -D_FORTIFY_SOURCE=0" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src
mv dest gdb-8.3.1
cd gdb-8.3.1
rm -rf bin/gdb-add-index include lib share

7z -mx0 a ../gdb-8.3.1.7z *
