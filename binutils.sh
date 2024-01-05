#!/bin/sh

source ./0_append_distro_path.sh

untar_file binutils-2.37.tar

# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=999566402e3d7c69032bbf47e28b44fc0926fe62
patch -d $X_WORK_DIR/binutils-2.37 -p1 < binutils-fix-uint.patch

cd $X_WORK_DIR
mv binutils-2.37 src
mkdir build dest
cd build

../src/configure --disable-nls --disable-shared --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 \
--target=x86_64-w64-mingw32 --disable-multilib --prefix=$X_WORK_DIR/dest --with-sysroot=$X_WORK_DIR/dest

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd $X_WORK_DIR
rm -rf build src
mv dest binutils-2.37
cd binutils-2.37
rm -rf lib/*.la share

7z -mx0 a ../binutils-2.37.7z *
