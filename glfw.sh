#!/bin/sh

source ./0_append_distro_path.sh

untar_file glfw-3.3.5.tar

cd $X_WORK_DIR
mv glfw-3.3.5 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DWIN32=ON" \
"-DGLFW_BUILD_DOCS=OFF" \
"-DGLFW_BUILD_EXAMPLES=OFF" \
"-DGLFW_BUILD_TESTS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install
cd $X_WORK_DIR
rm -rf build src
mv dest glfw-3.3.5
cd glfw-3.3.5
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../glfw-3.3.5.7z *
