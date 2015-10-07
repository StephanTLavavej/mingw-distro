#!/bin/sh

source ./0_append_distro_path.sh

7z x '-oC:\Temp\gcc' libjpeg-turbo-1.4.2.tar > /dev/null || fail_with libjpeg-turbo-1.4.2.tar - EPIC FAIL

cd /c/temp/gcc
mv libjpeg-turbo-1.4.2 src
mkdir -p build dest/bin dest/include dest/lib
cd build
cmake -G "Unix Makefiles" "-DCMAKE_C_FLAGS=-s -O3 -DTWO_FILE_COMMANDLINE -Wno-attributes" /c/temp/gcc/src || fail_with libjpeg-turbo 1 - EPIC FAIL
# make install must NOT be used, as it will contaminate the Windows system directory.
make $X_MAKE_JOBS || fail_with libjpeg-turbo 2 - EPIC FAIL
cd /c/temp/gcc
mv build/jpegtran-static.exe dest/bin/jpegtran.exe || fail_with libjpeg-turbo 3 - EPIC FAIL
mv build/jconfig.h src/jerror.h src/jmorecfg.h src/jpeglib.h src/turbojpeg.h dest/include || fail_with libjpeg-turbo 4 - EPIC FAIL
mv build/libjpeg.a build/libturbojpeg.a dest/lib || fail_with libjpeg-turbo 5 - EPIC FAIL
rm -rf build src
mv dest libjpeg-turbo-1.4.2
cd libjpeg-turbo-1.4.2

7z -mx0 a ../libjpeg-turbo-1.4.2.7z *
