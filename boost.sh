#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' boost_1_52_0.tar > NUL || { echo boost_1_52_0.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/boost_1_52_0 -p1 < boost-BOOST_THREAD_USE_LIB.patch
patch -d /c/temp/gcc/boost_1_52_0 -p1 < boost-bootstrap.patch

cd /c/temp/gcc
mv boost_1_52_0 src
mkdir -p dest/include
cd src
bootstrap.sh || { echo boost - EPIC FAIL ; exit 1; }
echo "using gcc : : : <compileflags>-fomit-frame-pointer <compileflags>-Wno-attributes ;" >> tools/build/v2/user-config.jam

# --without-context : https://svn.boost.org/trac/boost/ticket/7262
b2 -j$NUMBER_OF_PROCESSORS --without-context variant=release link=static runtime-link=static --stagedir=/c/temp/gcc/dest stage -sNO_BZIP2 -sBZIP2_BINARY=bz2 -sBZIP2_INCLUDE=/c/mingw/include -sBZIP2_LIBPATH=/c/mingw/lib -sNO_ZLIB -sZLIB_BINARY=z -sZLIB_INCLUDE=/c/mingw/include -sZLIB_LIBPATH=/c/mingw/lib || { echo boost - EPIC FAIL ; exit 1; }

cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
mv dest boost-1.52.0

echo Packaging...

cd boost-1.52.0
7za -mx0 a ../boost-1.52.0.7z * > NUL || { echo boost-1.52.0.7z - EPIC FAIL ; exit 1; }

echo Cleaning...

cd /c/temp/gcc
rm -rf src

echo Done.
