#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' grep-2.10.tar > NUL || fail_with grep-2.10.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' lame-3.99.5.tar > NUL || fail_with lame-3.99.5.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' make-3.82.tar > NUL || fail_with make-3.82.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' sed-4.2.2.tar > NUL || fail_with sed-4.2.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' wget-1.14.tar > NUL || fail_with wget-1.14.tar - EPIC FAIL

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch
patch -d /c/temp/gcc/sed-4.2.2 -p1 < sed.patch
patch -d /c/temp/gcc/wget-1.14 -p1 < wget.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls --disable-largefile || fail_with grep - EPIC FAIL
make "CFLAGS=-s -O3" || fail_with grep - EPIC FAIL
mv src/grep.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv lame-3.99.5 src
mkdir build
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest || fail_with lame - EPIC FAIL
make "CFLAGS=-O3" "LDFLAGS=-s" || fail_with lame - EPIC FAIL
mv frontend/lame.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv make-3.82 src
mkdir build
cd build
# make 3.82 doesn't have a job server on Windows, but 3.83 will.
../src/configure --prefix=/c/temp/gcc/dest --enable-case-insensitive-file-system --disable-job-server --disable-nls --disable-rpath || fail_with make - EPIC FAIL
sed -e "s/#define PATH_SEPARATOR_CHAR ':'/#define PATH_SEPARATOR_CHAR ';'/" config.h > config.fixed
mv -f config.fixed config.h
make "CFLAGS=-O3" "LDFLAGS=-s" || fail_with make - EPIC FAIL
mv make.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv sed-4.2.2 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with sed - EPIC FAIL
make "CFLAGS=-O3" "LDFLAGS=-s" || fail_with sed - EPIC FAIL
mv sed/sed.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv wget-1.14 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls --without-ssl || fail_with wget - EPIC FAIL
make "CFLAGS=-O3" "LDFLAGS=-s" || fail_with wget - EPIC FAIL
mv src/wget.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv dest grep+lame+make+sed+wget
cd grep+lame+make+sed+wget

7z -mx0 a ../grep+lame+make+sed+wget.7z *
