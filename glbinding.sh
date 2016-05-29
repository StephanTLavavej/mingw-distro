#!/bin/sh

source ./0_append_distro_path.sh

extract_file glbinding-2.0.0.zip

patch -d /c/temp/gcc/glbinding-2.0.0 -p1 < glbinding.patch

cd /c/temp/gcc
mv glbinding-2.0.0 src
mkdir build dest
cd build

cmake \
"-DBUILD_SHARED_LIBS=OFF" \
"-DCMAKE_CXX_FLAGS=-DGLBINDING_USE_BOOST_THREAD -DBOOST_THREAD_VERSION=4 -s -O3 -DSYSTEM_WINDOWS" \
"-DCMAKE_INSTALL_PREFIX=/c/temp/gcc/dest" \
"-DOPENGL_gl_LIBRARY=/c/mingw/x86_64-w64-mingw32/lib/libopengl32.a" \
"-DOPENGL_INCLUDE_DIR=/c/mingw/x86_64-w64-mingw32/include/gl" \
"-DOPTION_BUILD_TESTS=OFF" \
-G "Unix Makefiles" /c/temp/gcc/src || fail_with glbinding 1 - EPIC FAIL

make $X_MAKE_JOBS || fail_with glbinding 2 - EPIC FAIL
make install || fail_with glbinding 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest glbinding-2.0.0
cd glbinding-2.0.0
rm -rf cmake data AUTHORS glbinding-config.cmake README.md VERSION
mv LICENSE include/glbinding

7z -mx0 a ../glbinding-2.0.0.7z *
