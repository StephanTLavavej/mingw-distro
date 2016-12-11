#!/bin/sh

source ./0_append_distro_path.sh

extract_file pngcheck-2.3.0.tar
extract_file pngcrush-1.8.10-nolib.tar

cd /c/temp/gcc
mkdir -p dest/bin

gcc -s -O3 pngcheck-2.3.0/pngcheck.c -o dest/bin/pngcheck.exe -lpng -lz || fail_with pngcheck 1 - EPIC FAIL

gcc -s -O3 pngcrush-1.8.10-nolib/pngcrush.c -o dest/bin/pngcrush.exe -lpng -lz || fail_with pngcrush 1 - EPIC FAIL

rm -rf pngcheck-2.3.0 pngcrush-1.8.10-nolib
mv dest pngcheck+pngcrush
cd pngcheck+pngcrush

7z -mx0 a ../pngcheck+pngcrush.7z *
