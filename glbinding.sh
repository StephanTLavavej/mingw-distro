#!/bin/sh

source ./0_append_distro_path.sh

untar_file glbinding-3.1.0.tar

# https://github.com/cginternals/glbinding/pull/298 fixes https://github.com/StephanTLavavej/mingw-distro/issues/65
patch -d /c/temp/gcc/glbinding-3.1.0 -p1 < glbinding-pr-298.patch

cd /c/temp/gcc
mv glbinding-3.1.0 src
mkdir build dest
cd build

cmake \
"-DBUILD_SHARED_LIBS=OFF" \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_CXX_FLAGS=-DBOOST_THREAD_VERSION=4 -s -O3 -DSYSTEM_WINDOWS" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DOPTION_BUILD_EXAMPLES=OFF" \
"-DOPTION_BUILD_TESTS=OFF" \
"-DOPTION_BUILD_TOOLS=OFF" \
"-DOPTION_BUILD_WITH_BOOST_THREAD=ON" \
-G Ninja /c/temp/gcc/src

ninja
ninja install
cd /c/temp/gcc
rm -rf build src
mv dest glbinding-3.1.0
cd glbinding-3.1.0
rm -rf cmake AUTHORS glbinding-config.cmake README.md VERSION
mv LICENSE include/glbinding

7z -mx0 a ../glbinding-3.1.0.7z *
