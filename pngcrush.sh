#!/bin/sh

source ./0_append_distro_path.sh

untar_file pngcrush-1.8.13-nolib.tar

cd /c/temp/gcc
mv pngcrush-1.8.13-nolib src
mkdir -p dest/bin

gcc -s -O3 src/pngcrush.c -o dest/bin/pngcrush.exe -lpng -lz || fail_with pngcrush 1 - EPIC FAIL
rm -rf src
mv dest pngcrush-1.8.13
cd pngcrush-1.8.13

7z -mx0 a ../pngcrush-1.8.13.7z *
