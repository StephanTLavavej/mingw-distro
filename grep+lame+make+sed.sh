#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' grep-2.10.tar > NUL || fail_with grep-2.10.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' lame-3.99.5.tar > NUL || fail_with lame-3.99.5.tar - EPIC FAIL

# http://git.savannah.gnu.org/cgit/make.git/snapshot/make-a4937bc.tar.gz
7z x '-oC:\Temp\gcc' make-a4937bc.tar > NUL || fail_with make-a4937bc.tar - EPIC FAIL

7z x '-oC:\Temp\gcc' sed-4.2.2.tar > NUL || fail_with sed-4.2.2.tar - EPIC FAIL

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch
patch -d /c/temp/gcc/sed-4.2.2 -p1 < sed.patch

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


# Distilled from "build_w32.bat gcc".
# http://lists.gnu.org/archive/html/make-w32/2013-10/msg00029.html
# Eli Zaretskii> The only way to build a MinGW Make that is officially supported is build_w32.bat.

mv make-a4937bc src
cd src

# This is necessary for building from git.
sed -r -e 's/%PACKAGE%/make/' -e 's/%VERSION%/4.0/' config.h.W32.template > config.h.W32

mv config.h.W32 config.h

gcc -Wall -Wextra -Werror -s -O3 \
-Wno-parentheses -Wno-sign-compare -Wno-unused-but-set-variable -Wno-unused-label -Wno-unused-parameter \
-DHAVE_CONFIG_H -DWINDOWS32 -I. -Iglob -Iw32/include -Iw32/subproc \
-DHAVE_CASE_INSENSITIVE_FS \
ar.c arscan.c commands.c default.c dir.c expand.c file.c function.c getloadavg.c getopt.c getopt1.c \
guile.c \
hash.c implicit.c job.c load.c loadapi.c main.c misc.c output.c read.c remake.c remote-stub.c rule.c \
signame.c strcache.c variable.c version.c vpath.c glob/fnmatch.c glob/glob.c w32/pathstuff.c \
w32/compat/posixfcn.c w32/subproc/misc.c w32/subproc/sub_proc.c w32/subproc/w32err.c \
-o ../dest/bin/make.exe || fail_with make - EPIC FAIL

cd /c/temp/gcc
rm -rf src


mv sed-4.2.2 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with sed - EPIC FAIL
make "CFLAGS=-O3" "LDFLAGS=-s" || fail_with sed - EPIC FAIL
mv sed/sed.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv dest grep+lame+make+sed
cd grep+lame+make+sed

7z -mx0 a ../grep+lame+make+sed.7z *
