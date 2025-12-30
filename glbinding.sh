#!/bin/sh

source ./0_append_distro_path.sh

untar_file glbinding-3.5.0.tar

cd $X_WORK_DIR
mv glbinding-3.5.0 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_CXX_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DBUILD_SHARED_LIBS=OFF" \
"-DOPTION_BUILD_EXAMPLES=OFF" \
"-DOPTION_BUILD_TOOLS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest glbinding-3.5.0
cd glbinding-3.5.0
rm -rf cmake AUTHORS glbinding-config.cmake README.md VERSION
mv LICENSE include/glbinding

7z -mx0 a ../glbinding-3.5.0.7z *
