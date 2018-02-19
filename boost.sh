#!/bin/sh

source ./0_append_distro_path.sh

untar_file boost_1_66_0.tar

cd /c/temp/gcc
mv boost_1_66_0 src
mkdir -p dest/include
cd src
./bootstrap.sh

./b2 $X_B2_JOBS variant=release link=static runtime-link=static threading=multi --stagedir=/c/temp/gcc/dest stage \
address-model=64 \
-sNO_BZIP2 -sBZIP2_BINARY=bz2 -sBZIP2_INCLUDE=$X_DISTRO_INC -sBZIP2_LIBPATH=$X_DISTRO_LIB \
-sNO_ZLIB -sZLIB_BINARY=z -sZLIB_INCLUDE=$X_DISTRO_INC -sZLIB_LIBPATH=$X_DISTRO_LIB

cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
rm -rf src

mv dest boost-1.66.0
cd boost-1.66.0

7z -mx0 a ../boost-1.66.0.7z *
