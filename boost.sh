#!/bin/sh

source ./0_append_distro_path.sh

untar_file boost_1_84_0.tar

# https://github.com/StephanTLavavej/mingw-distro/issues/95
patch -d $X_WORK_DIR/boost_1_84_0 -p1 < boost-fix-raw_maxline.patch

cd $X_WORK_DIR
mv boost_1_84_0 src
mkdir -p dest/include
cd src

./bootstrap.sh

./b2 $X_B2_JOBS address-model=64 link=static runtime-link=static threading=multi variant=release \
--stagedir=$X_WORK_DIR/dest stage

cd $X_WORK_DIR/dest/lib
for i in *.a; do mv $i ${i%-mgw*.a}.a; done
cd $X_WORK_DIR
mv src/boost dest/include
rm -rf src

mv dest boost-1.84.0
cd boost-1.84.0
rm -rf lib/cmake

7z -mx0 a ../boost-1.84.0.7z *
