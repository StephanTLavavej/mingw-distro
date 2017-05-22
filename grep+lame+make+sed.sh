#!/bin/sh

source ./0_append_distro_path.sh

extract_file grep-2.10.tar
extract_file lame-3.99.5.tar
extract_file make-4.2.1.tar
extract_file sed-4.4.tar

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls --disable-largefile "CFLAGS=-s -O3 -DPCRE_STATIC" \
|| fail_with grep 1 - EPIC FAIL

make $X_MAKE_JOBS || fail_with grep 2 - EPIC FAIL
mv src/grep.exe ../dest/bin || fail_with grep 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv lame-3.99.5 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest || fail_with lame 1 - EPIC FAIL

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s" || fail_with lame 2 - EPIC FAIL
mv frontend/lame.exe ../dest/bin || fail_with lame 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv make-4.2.1 src
cd src
cmd /c "build_w32.bat gcc"
strip -s GccRel/gnumake.exe || fail_with make 1 - EPIC FAIL
mv GccRel/gnumake.exe ../dest/bin/make.exe || fail_with make 2 - EPIC FAIL
# mingw32-make.exe is for CMake.
cp ../dest/bin/make.exe ../dest/bin/mingw32-make.exe || fail_with make 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf src

mv sed-4.4 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest || fail_with sed 1 - EPIC FAIL

make $X_MAKE_JOBS "CFLAGS=-O3" "LDFLAGS=-s" || fail_with sed 2 - EPIC FAIL
mv sed/sed.exe ../dest/bin || fail_with sed 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest grep+lame+make+sed
cd grep+lame+make+sed

7z -mx0 a ../grep+lame+make+sed.7z *
