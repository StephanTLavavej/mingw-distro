#!/bin/sh

source ./0_append_distro_path.sh

untar_file optipng-0.7.7.tar

cd /c/temp/gcc
mv optipng-0.7.7 src
mkdir dest
cd src

# "note: building outside the source directory tree is not supported"
./configure --prefix=/c/temp/gcc/dest --with-system-libs

make $X_MAKE_JOBS all "CFLAGS=-O3" "LDFLAGS=-s"
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf src
mv dest optipng-0.7.7
cd optipng-0.7.7
rm -rf man

7z -mx0 a ../optipng-0.7.7.7z *
