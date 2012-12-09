#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' binutils-2.23.1.tar > NUL || { echo binutils-2.23.1.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/binutils-2.23.1 -p1 < binutils.patch

cd /c/temp/gcc
mv binutils-2.23.1 src
mkdir build dest
cd build
../src/configure --disable-nls --disable-shared --prefix=/c/temp/gcc/dest || { echo binutils - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" || { echo binutils - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest binutils-2.23.1
cd binutils-2.23.1
mv i686-pc-mingw32/bin/* bin
mv i686-pc-mingw32/lib/* lib
rm -rf i686-pc-mingw32 lib/*.la share
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../binutils-2.23.1.7z *
