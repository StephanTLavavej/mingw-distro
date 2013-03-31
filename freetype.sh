#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' freetype-2.4.10.tar > NUL || fail_with freetype-2.4.10.tar - EPIC FAIL

patch -d /c/temp/gcc/freetype-2.4.10 -p1 < freetype-cflags.patch
patch -d /c/temp/gcc/freetype-2.4.10 -p1 < freetype-include.patch

cd /c/temp/gcc
mv freetype-2.4.10 src
mkdir build dest
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest || fail_with freetype - EPIC FAIL
make all install || fail_with freetype - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest/include/freetype2/freetype dest/include
rmdir dest/include/freetype2
mv dest/include/freetype dest/include/freetype2
sed -e "s@<freetype/@<freetype2/@" dest/include/freetype2/config/ftheader.h > dest/include/freetype2/config/ftheader-fixed.h
mv -f dest/include/freetype2/config/ftheader-fixed.h dest/include/freetype2/config/ftheader.h

mv dest freetype-2.4.10
cd freetype-2.4.10
rm -rf bin lib/pkgconfig lib/*.la share

7za -mx0 a ../freetype-2.4.10.7z *
