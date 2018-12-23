#!/bin/sh

source ./0_append_distro_path.sh

untar_file glbinding-3.0.2.tar

cd /c/temp/gcc
mv glbinding-3.0.2 src
mkdir build dest
cd build

cmake \
"-DBUILD_SHARED_LIBS=OFF" \
"-DCMAKE_CXX_FLAGS=-DBOOST_THREAD_VERSION=4 -s -O3 -DSYSTEM_WINDOWS" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DOPTION_BUILD_EXAMPLES=OFF" \
"-DOPTION_BUILD_TESTS=OFF" \
"-DOPTION_BUILD_TOOLS=OFF" \
"-DOPTION_BUILD_WITH_BOOST_THREAD=ON" \
-G "Unix Makefiles" /c/temp/gcc/src

make $X_MAKE_JOBS
make $X_MAKE_JOBS install
cd /c/temp/gcc
rm -rf build src
mv dest glbinding-3.0.2
cd glbinding-3.0.2
rm -rf cmake AUTHORS glbinding-config.cmake README.md VERSION
mv LICENSE include/glbinding

7z -mx0 a ../glbinding-3.0.2.7z *
