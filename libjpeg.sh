#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' jpegsrc.v9.tar > NUL || { echo jpegsrc.v9.tar - EPIC FAIL ; exit 1; }

cp libjpeg.patch /c/temp/gcc/jpeg-9

cd /c/temp/gcc
mkdir -p libjpeg-9/bin libjpeg-9/include libjpeg-9/lib
cd jpeg-9
configure --disable-shared || { echo libjpeg - EPIC FAIL ; exit 1; }
make "CFLAGS=-O3 -fomit-frame-pointer -DTWO_FILE_COMMANDLINE" "LDFLAGS=-s" || { echo libjpeg - EPIC FAIL ; exit 1; }
mv jpegtran.exe ../libjpeg-9/bin
mv jconfig.h jerror.h jmorecfg.h jpeglib.h ../libjpeg-9/include
mv .libs/libjpeg.a ../libjpeg-9/lib
cd /c/temp/gcc
patch -d libjpeg-9 -p1 < jpeg-9/libjpeg.patch
sed -re 's/\b(boolean|FALSE|TRUE)\b/JPEG_\1/g' libjpeg-9/include/jpeglib.h > libjpeg-9/include/jpeglib.h.fixed
mv -f libjpeg-9/include/jpeglib.h.fixed libjpeg-9/include/jpeglib.h
rm -rf jpeg-9
cd libjpeg-9
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../libjpeg-9.7z *
