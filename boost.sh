#!/bin/sh

source ./0_append_distro_path.sh

untar_file boost_1_69_0.tar

cd /c/temp/gcc
mv boost_1_69_0 src
mkdir -p dest/include
cd src

./bootstrap.sh

./b2 $X_B2_JOBS address-model=64 link=static runtime-link=static threading=multi variant=release \
--stagedir=/c/temp/gcc/dest stage

cd /c/temp/gcc/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd /c/temp/gcc
mv src/boost dest/include
rm -rf src

mv dest boost-1.69.0
cd boost-1.69.0

7z -mx0 a ../boost-1.69.0.7z *
