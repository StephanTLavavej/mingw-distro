#!/bin/sh

source ./0_append_distro_path.sh

untar_file pcre2-10.37.tar

cd $X_WORK_DIR
mv pcre2-10.37 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DPCRE2_BUILD_PCRE2_16=ON" \
"-DPCRE2_BUILD_PCRE2_32=ON" \
"-DPCRE2_BUILD_TESTS=OFF" \
"-DPCRE2_NEWLINE=ANYCRLF" \
"-DPCRE2_SUPPORT_JIT=ON" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest pcre2-10.37
cd pcre2-10.37
rm -rf bin/pcre2-config lib/pkgconfig man share
# Avoid colliding with the original PCRE library.
# cp include/pcre2posix.h include/regex.h

7z -mx0 a ../pcre2-10.37.7z *
