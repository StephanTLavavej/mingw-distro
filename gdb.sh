#!/bin/sh

source ./0_append_distro_path.sh

untar_file gdb-11.1.tar
untar_file gmp-6.2.1.tar

cd $X_WORK_DIR

# Build gmp.
mv gmp-6.2.1 src-gmp
mkdir build-gmp dest-gmp
cd build-gmp

../src-gmp/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest-gmp --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build-gmp src-gmp
rm -rf dest-gmp/lib/*.la dest-gmp/lib/pkgconfig dest-gmp/share

# Build gdb.
mv gdb-11.1 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest --disable-nls

# -D_FORTIFY_SOURCE=0 works around https://github.com/StephanTLavavej/mingw-distro/issues/71
make $X_MAKE_JOBS all \
"CFLAGS=-O3 -D_FORTIFY_SOURCE=0 -I$X_WORK_DIR/dest-gmp/include" \
"CXXFLAGS=-O3 -D_FORTIFY_SOURCE=0 -I$X_WORK_DIR/dest-gmp/include" \
"LDFLAGS=-s -L$X_WORK_DIR/dest-gmp/lib"

make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build src dest-gmp
mv dest gdb-11.1
cd gdb-11.1
rm -rf bin/gdb-add-index include lib share

7z -mx0 a ../gdb-11.1.7z *
