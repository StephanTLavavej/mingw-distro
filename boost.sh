#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' boost_1_49_0.tar > NUL || { echo boost_1_49_0.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/boost_1_49_0 -p1 < boost-BOOST_THREAD_USE_LIB.patch
patch -d /c/temp/gcc/boost_1_49_0 -p1 < boost-bootstrap.patch
patch -d /c/temp/gcc/boost_1_49_0 -p1 < boost-c++11.patch

cd /c/temp/gcc
mv boost_1_49_0 src
mkdir -p dest/include
cd src
bootstrap.sh || { echo boost - EPIC FAIL ; exit 1; }
echo "using gcc : : : <compileflags>-fomit-frame-pointer <compileflags>-Wno-attributes <compileflags>-Wno-long-long ;" >> tools/build/v2/user-config.jam
b2 -j$NUMBER_OF_PROCESSORS variant=release link=static runtime-link=static --stagedir=/c/temp/gcc/dest stage -sNO_BZIP2 -sBZIP2_BINARY=bz2 -sBZIP2_INCLUDE=/c/mingw/include -sBZIP2_LIBPATH=/c/mingw/lib -sNO_ZLIB -sZLIB_BINARY=z -sZLIB_INCLUDE=/c/mingw/include -sZLIB_LIBPATH=/c/mingw/lib || { echo boost - EPIC FAIL ; exit 1; }
cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
mv dest boost-1.49.0

cd boost-1.49.0
7za -mx0 a ../boost-1.49.0.7z *

# Annoying!
cd /c/temp/gcc
rm -rf src
sleep 45
rm -rf src
