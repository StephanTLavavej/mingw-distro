#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' freetype-2.4.9.tar > NUL || { echo freetype-2.4.9.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/freetype-2.4.9 -p1 < freetype-cflags.patch
patch -d /c/temp/gcc/freetype-2.4.9 -p1 < freetype-include.patch

cd /c/temp/gcc
mv freetype-2.4.9 src
mkdir build dest
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest || { echo freetype - EPIC FAIL ; exit 1; }
make all install || { echo freetype - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv dest/include/freetype2/freetype dest/include
rmdir dest/include/freetype2
mv dest/include/freetype dest/include/freetype2
sed -e "s@<freetype/@<freetype2/@" dest/include/freetype2/config/ftheader.h > dest/include/freetype2/config/ftheader-fixed.h
rm dest/include/freetype2/config/ftheader.h
mv dest/include/freetype2/config/ftheader-fixed.h dest/include/freetype2/config/ftheader.h

mv dest freetype-2.4.9
cd freetype-2.4.9
rm -rf bin lib/pkgconfig lib/*.la share

7za -mx0 a ../freetype-2.4.9.7z *
