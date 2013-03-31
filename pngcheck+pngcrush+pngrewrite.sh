#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' pngcheck-2.3.0.tar > NUL || fail_with pngcheck-2.3.0.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' pngcrush-1.7.47-nolib.tar > NUL || fail_with pngcrush-1.7.47-nolib.tar - EPIC FAIL
7za x '-oC:\Temp\gcc\pngrewrite-1.4.0' pngrewrite-1.4.0.zip > NUL || fail_with pngrewrite-1.4.0.zip - EPIC FAIL

cd /c/temp/gcc
mkdir -p dest/bin

gcc -s -O3 -fomit-frame-pointer pngcheck-2.3.0/pngcheck.c -o dest/bin/pngcheck.exe -lpng -lz || fail_with pngcheck - EPIC FAIL

gcc -s -O3 -fomit-frame-pointer pngcrush-1.7.47-nolib/pngcrush.c -o dest/bin/pngcrush.exe -lpng -lz || fail_with pngcrush - EPIC FAIL

gcc -s -O3 -fomit-frame-pointer pngrewrite-1.4.0/*.c -o dest/bin/pngrewrite.exe -lpng -lz || fail_with pngrewrite - EPIC FAIL

rm -rf pngcheck-2.3.0 pngcrush-1.7.47-nolib pngrewrite-1.4.0
mv dest pngcheck+pngcrush+pngrewrite
cd pngcheck+pngcrush+pngrewrite
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../pngcheck+pngcrush+pngrewrite.7z *
