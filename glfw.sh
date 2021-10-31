#!/bin/sh

source ./0_append_distro_path.sh

untar_file glfw-3.3.5.tar

cd /c/temp/gcc
mv glfw-3.3.5 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DWIN32=ON" \
"-DGLFW_BUILD_DOCS=OFF" \
"-DGLFW_BUILD_EXAMPLES=OFF" \
"-DGLFW_BUILD_TESTS=OFF" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest glfw-3.3.5
cd glfw-3.3.5
rm -rf lib/cmake lib/pkgconfig

7z -mx0 a ../glfw-3.3.5.7z *
