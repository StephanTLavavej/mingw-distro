#!/bin/sh

source ./0_append_distro_path.sh

untar_file pcre-8.45.tar

cd $X_WORK_DIR
mv pcre-8.45 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_CXX_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DPCRE_BUILD_PCRE16=ON" \
"-DPCRE_BUILD_PCRE32=ON" \
"-DPCRE_BUILD_TESTS=OFF" \
"-DPCRE_NEWLINE=ANYCRLF" \
"-DPCRE_SUPPORT_JIT=ON" \
"-DPCRE_SUPPORT_UNICODE_PROPERTIES=ON" \
"-DPCRE_SUPPORT_UTF=ON" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest pcre-8.45
cd pcre-8.45
rm -rf bin/pcre-config lib/pkgconfig man share
cp include/pcreposix.h include/regex.h

7z -mx0 a ../pcre-8.45.7z *
