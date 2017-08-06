#!/bin/sh

source ./0_append_distro_path.sh

extract_file pcre2-10.23.tar

cd /c/temp/gcc
mv pcre2-10.23 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared --enable-pcre2-16 --enable-pcre2-32 \
--enable-jit --enable-newline-is-anycrlf "CFLAGS=-s -O3" || fail_with pcre2 1 - EPIC FAIL

make $X_MAKE_JOBS all || fail_with pcre2 2 - EPIC FAIL
make install || fail_with pcre2 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest pcre2-10.23
cd pcre2-10.23
rm -rf bin/pcre2-config lib/pkgconfig lib/*.la share
cp include/pcre2posix.h include/regex.h

7z -mx0 a ../pcre2-10.23.7z *
