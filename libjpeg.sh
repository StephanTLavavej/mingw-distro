#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' jpegsrc.v8d.tar > NUL || { echo jpegsrc.v8d.tar - EPIC FAIL ; exit 1; }

cp libjpeg.patch /c/temp/gcc/jpeg-8d

cd /c/temp/gcc
mkdir -p libjpeg-8d/bin libjpeg-8d/include libjpeg-8d/lib
cd jpeg-8d
configure --disable-shared || { echo libjpeg - EPIC FAIL ; exit 1; }
make "CFLAGS=-Os -fomit-frame-pointer -DTWO_FILE_COMMANDLINE" "LDFLAGS=-s" || { echo libjpeg - EPIC FAIL ; exit 1; }
mv jpegtran.exe ../libjpeg-8d/bin
mv jconfig.h jerror.h jmorecfg.h jpeglib.h ../libjpeg-8d/include
mv .libs/libjpeg.a ../libjpeg-8d/lib
cd /c/temp/gcc
patch -d libjpeg-8d -p1 < jpeg-8d/libjpeg.patch
sed -re 's/\b(boolean|FALSE|TRUE)\b/JPEG_\1/g' libjpeg-8d/include/jpeglib.h > libjpeg-8d/include/jpeglib.h.fixed
mv -f libjpeg-8d/include/jpeglib.h.fixed libjpeg-8d/include/jpeglib.h
rm -rf jpeg-8d
cd libjpeg-8d
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../libjpeg-8d.7z *
