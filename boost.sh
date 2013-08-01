#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' boost_1_54_0.tar > NUL || fail_with boost_1_54_0.tar - EPIC FAIL

patch -d /c/temp/gcc/boost_1_54_0 -p1 < boost-bootstrap.patch
patch -d /c/temp/gcc/boost_1_54_0 -p1 < boost-official.patch

cd /c/temp/gcc
mv boost_1_54_0 src
mkdir -p dest/include
cd src
bootstrap.sh || fail_with boost - EPIC FAIL
echo "using gcc : : : <compileflags>-fomit-frame-pointer <compileflags>-Wno-attributes ;" >> tools/build/v2/user-config.jam

# --without-context : https://svn.boost.org/trac/boost/ticket/7262
b2 -j$NUMBER_OF_PROCESSORS --without-context --without-coroutine variant=release link=static runtime-link=static threading=multi --stagedir=/c/temp/gcc/dest stage -sNO_BZIP2 -sBZIP2_BINARY=bz2 -sBZIP2_INCLUDE=/c/mingw/include -sBZIP2_LIBPATH=/c/mingw/lib -sNO_ZLIB -sZLIB_BINARY=z -sZLIB_INCLUDE=/c/mingw/include -sZLIB_LIBPATH=/c/mingw/lib || fail_with boost - EPIC FAIL

cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
mv dest boost-1.54.0

echo Packaging...

cd boost-1.54.0
7z -mx0 a ../boost-1.54.0.7z * > NUL || fail_with boost-1.54.0.7z - EPIC FAIL

echo Cleaning...

cd /c/temp/gcc
rm -rf src

echo Done.
