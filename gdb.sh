#!/bin/sh

source ./0_append_distro_path.sh

untar_file gdb-14.1.tar
untar_file gmp-6.3.0.tar
untar_file mpfr-4.2.1.tar

cd $X_WORK_DIR

# Build gmp.
mv gmp-6.3.0 src-gmp
mkdir build-gmp dest-gmp
cd build-gmp

../src-gmp/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest-gmp --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build-gmp src-gmp
rm -rf dest-gmp/lib/*.la dest-gmp/lib/pkgconfig dest-gmp/share

# Build mpfr.
mv mpfr-4.2.1 src-mpfr
mkdir build-mpfr dest-mpfr
cd build-mpfr

../src-mpfr/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest-mpfr --disable-shared --with-gmp=$X_WORK_DIR/dest-gmp

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build-mpfr src-mpfr
rm -rf dest-mpfr/lib/*.la dest-mpfr/lib/pkgconfig dest-mpfr/share

# Build gdb.
mv gdb-14.1 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest --disable-nls --with-gmp=$X_WORK_DIR/dest-gmp --with-mpfr=$X_WORK_DIR/dest-mpfr

make $X_MAKE_JOBS all \
"CFLAGS=-O3" \
"CXXFLAGS=-O3" \
"LDFLAGS=-s"

make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build src dest-gmp dest-mpfr
mv dest gdb-14.1
cd gdb-14.1
rm -rf bin/gdb-add-index include lib share

7z -mx0 a ../gdb-14.1.7z *
