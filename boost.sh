#!/bin/sh

source ./0_append_distro_path.sh

untar_file boost_1_77_0.tar

cd $X_WORK_DIR
mv boost_1_77_0 src
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

mv dest boost-1.77.0
cd boost-1.77.0
rm -rf lib/cmake

7z -mx0 a ../boost-1.77.0.7z *
