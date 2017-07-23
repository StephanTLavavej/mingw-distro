#!/bin/sh

source ./0_append_distro_path.sh

extract_file pngcheck-2.3.0.tar

cd /c/temp/gcc
mv pngcheck-2.3.0 src
mkdir -p dest/bin

gcc -s -O3 src/pngcheck.c -o dest/bin/pngcheck.exe || fail_with pngcheck 1 - EPIC FAIL
rm -rf src
mv dest pngcheck-2.3.0
cd pngcheck-2.3.0

7z -mx0 a ../pngcheck-2.3.0.7z *
