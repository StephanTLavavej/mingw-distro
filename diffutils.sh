#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' diffutils-3.2.tar > NUL || { echo diffutils-3.2.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/diffutils-3.2 -p1 < diffutils.patch

cd /c/temp/gcc
mv diffutils-3.2 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo diffutils - EPIC FAIL ; exit 1; }
touch man/cmp.1 man/diff.1 man/diff3.1 man/sdiff.1
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || { echo diffutils - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest diffutils-3.2
cd diffutils-3.2
rm -rf share
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../diffutils-3.2.7z *
