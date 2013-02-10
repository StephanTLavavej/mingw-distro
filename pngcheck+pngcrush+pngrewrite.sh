#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' pngcheck-2.3.0.tar > NUL || { echo pngcheck-2.3.0.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' pngcrush-1.7.47-nolib.tar > NUL || { echo pngcrush-1.7.47-nolib.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc\pngrewrite-1.4.0' pngrewrite-1.4.0.zip > NUL || { echo pngrewrite-1.4.0.zip - EPIC FAIL ; exit 1; }

cd /c/temp/gcc
mkdir -p dest/bin

gcc -s -Os -fomit-frame-pointer pngcheck-2.3.0/pngcheck.c -o dest/bin/pngcheck.exe -lpng -lz || { echo pngcheck - EPIC FAIL ; exit 1; }

gcc -s -Os -fomit-frame-pointer pngcrush-1.7.47-nolib/pngcrush.c -o dest/bin/pngcrush.exe -lpng -lz || { echo pngcrush - EPIC FAIL ; exit 1; }

gcc -s -Os -fomit-frame-pointer pngrewrite-1.4.0/*.c -o dest/bin/pngrewrite.exe -lpng -lz || { echo pngrewrite - EPIC FAIL ; exit 1; }

rm -rf pngcheck-2.3.0 pngcrush-1.7.47-nolib pngrewrite-1.4.0
mv dest pngcheck+pngcrush+pngrewrite
cd pngcheck+pngcrush+pngrewrite
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../pngcheck+pngcrush+pngrewrite.7z *
