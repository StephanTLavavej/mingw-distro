#!/bin/sh

source ./0_append_distro_path.sh

7z x '-oC:\Temp\gcc' grep-2.10.tar > /dev/null || fail_with grep-2.10.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' lame-3.99.5.tar > /dev/null || fail_with lame-3.99.5.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' make-4.1.tar > /dev/null || fail_with make-4.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' sed-4.2.2.tar > /dev/null || fail_with sed-4.2.2.tar - EPIC FAIL

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch
patch -d /c/temp/gcc/sed-4.2.2 -p1 < sed.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls --disable-largefile || fail_with grep 1 - EPIC FAIL

make $X_MAKE_JOBS "CFLAGS=-s -O3" || fail_with grep 2 - EPIC FAIL
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


# Distilled from "build_w32.bat gcc".
# http://lists.gnu.org/archive/html/make-w32/2013-10/msg00029.html
# Eli Zaretskii> The only way to build a MinGW Make that is officially supported is build_w32.bat.

mv make-4.1 src
cd src

mv config.h.W32 config.h

gcc -s -O3 \
-DHAVE_CONFIG_H -DWINDOWS32 -I. -Iglob -Iw32/include -Iw32/subproc \
-DHAVE_CASE_INSENSITIVE_FS \
ar.c arscan.c commands.c default.c dir.c expand.c file.c function.c getloadavg.c getopt.c getopt1.c guile.c hash.c \
implicit.c job.c load.c loadapi.c main.c misc.c output.c read.c remake.c remote-stub.c rule.c signame.c strcache.c \
variable.c version.c vpath.c glob/fnmatch.c glob/glob.c \
w32/pathstuff.c w32/compat/posixfcn.c w32/subproc/misc.c w32/subproc/sub_proc.c w32/subproc/w32err.c \
-o ../dest/bin/make.exe || fail_with make 1 - EPIC FAIL

# For CMake.
cp ../dest/bin/make.exe ../dest/bin/mingw32-make.exe || fail_with make 2 - EPIC FAIL

cd /c/temp/gcc
rm -rf src


mv sed-4.2.2 src
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
