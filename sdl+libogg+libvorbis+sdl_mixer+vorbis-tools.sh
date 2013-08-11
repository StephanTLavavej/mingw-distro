#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' SDL-2.0.0-7469.tar > NUL || fail_with SDL-2.0.0-7469.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' libogg-1.3.1.tar > NUL || fail_with libogg-1.3.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' libvorbis-1.3.3.tar > NUL || fail_with libvorbis-1.3.3.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' SDL_mixer-2.0.0-650.tar > NUL || fail_with SDL_mixer-2.0.0-650.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' vorbis-tools-1.4.0.tar > NUL || fail_with vorbis-tools-1.4.0.tar - EPIC FAIL

patch -d /c/temp/gcc/SDL -p1 < sdl-clipcursor.patch

cd /c/temp/gcc

mv SDL src
mkdir build dest
cd build
sed -re "s/ -XCClinker -static-libgcc//" ../src/configure > configure-fixed
mv -f configure-fixed ../src/configure
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with SDL - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with SDL - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.1 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libogg - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with libogg - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.3 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libvorbis - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with libvorbis - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv SDL_mixer src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with SDL_mixer - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with SDL_mixer - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.0 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls || fail_with vorbis-tools - EPIC FAIL
make all install "CFLAGS=-s -O3" || fail_with vorbis-tools - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf bin/sdl2-config lib/pkgconfig lib/*.la share

7z -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
