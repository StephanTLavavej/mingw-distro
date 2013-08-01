#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' diffutils-3.3.tar > NUL || fail_with diffutils-3.3.tar - EPIC FAIL

patch -d /c/temp/gcc/diffutils-3.3 -p1 < diffutils.patch

cd /c/temp/gcc
mv diffutils-3.3 src
mkdir build dest
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with diffutils - EPIC FAIL
touch man/cmp.1 man/diff.1 man/diff3.1 man/sdiff.1
make all install "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with diffutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest diffutils-3.3
cd diffutils-3.3
rm -rf share
find -name "*.exe" -type f -print -exec strip -s {} ";"

7z -mx0 a ../diffutils-3.3.7z *
