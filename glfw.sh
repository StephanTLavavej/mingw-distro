#!/bin/sh

source ./0_append_distro_path.sh

untar_file glfw-3.4.tar

cd $X_WORK_DIR
mv glfw-3.4 src
mkdir build dest
cd build

export PATH=$PATH:/mingw64/bin
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DGLFW_BUILD_DOCS=OFF" \
"-DGLFW_BUILD_EXAMPLES=OFF" \
"-DGLFW_BUILD_TESTS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src
mv dest glfw-3.4
cd glfw-3.4
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../glfw-3.4.7z *
