#!/bin/sh

source ./0_append_distro_path.sh

extract_file libjpeg-turbo-1.5.1.tar

cd /c/temp/gcc
mv libjpeg-turbo-1.5.1 src
mkdir -p build dest/bin dest/include dest/lib
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --disable-shared \
--prefix=/c/temp/gcc/dest "CFLAGS=-s -O3 -DTWO_FILE_COMMANDLINE" || fail_with libjpeg-turbo 1 - EPIC FAIL

# make install must NOT be used, as it will contaminate the Windows system directory.
make $X_MAKE_JOBS || fail_with libjpeg-turbo 2 - EPIC FAIL
cd /c/temp/gcc
mv build/jpegtran.exe dest/bin/jpegtran.exe || fail_with libjpeg-turbo 3 - EPIC FAIL

mv build/jconfig.h src/jerror.h src/jmorecfg.h src/jpeglib.h src/turbojpeg.h dest/include \
|| fail_with libjpeg-turbo 4 - EPIC FAIL

mv build/.libs/libjpeg.a build/.libs/libturbojpeg.a dest/lib || fail_with libjpeg-turbo 5 - EPIC FAIL
rm -rf build src
mv dest libjpeg-turbo-1.5.1
cd libjpeg-turbo-1.5.1

7z -mx0 a ../libjpeg-turbo-1.5.1.7z *
