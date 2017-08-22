#!/bin/sh

source ./0_append_distro_path.sh

untar_file boost_1_65_0.tar

cd /c/temp/gcc
mv boost_1_65_0 src
mkdir -p dest/include
cd src
./bootstrap.sh || fail_with boost 1 - EPIC FAIL

# --without-stacktrace : A fix has been checked in for 1.66.0. (8/21/2017)
./b2 $X_B2_JOBS --without-stacktrace \
variant=release link=static runtime-link=static threading=multi --stagedir=/c/temp/gcc/dest stage \
-sNO_BZIP2 -sBZIP2_BINARY=bz2 -sBZIP2_INCLUDE=$X_DISTRO_INC -sBZIP2_LIBPATH=$X_DISTRO_LIB \
-sNO_ZLIB -sZLIB_BINARY=z -sZLIB_INCLUDE=$X_DISTRO_INC -sZLIB_LIBPATH=$X_DISTRO_LIB || fail_with boost 2 - EPIC FAIL

cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
mv dest boost-1.65.0

cd boost-1.65.0
7z -mx0 a ../boost-1.65.0.7z * || fail_with boost-1.65.0.7z - EPIC FAIL

cd /c/temp/gcc
rm -rf src
