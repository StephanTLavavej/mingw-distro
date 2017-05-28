#!/bin/sh

source ./0_append_distro_path.sh

extract_file zlib-1.2.11.tar

cd /c/temp/gcc
mv zlib-1.2.11 src
mkdir -p dest/include dest/lib
cd src
# -DTOO_FAR=32767 : http://optipng.sourceforge.net/pngtech/too_far.html
gcc -DTOO_FAR=32767 -s -O3 -c *.c || fail_with zlib 1 - EPIC FAIL
ar rs ../dest/lib/libz.a *.o || fail_with zlib 2 - EPIC FAIL
mv zconf.h zlib.h ../dest/include
cd /c/temp/gcc
rm -rf src
mv dest zlib-1.2.11
cd zlib-1.2.11

7z -mx0 a ../zlib-1.2.11.7z *
