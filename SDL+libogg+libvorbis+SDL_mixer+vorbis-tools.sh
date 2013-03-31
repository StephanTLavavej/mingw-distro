#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' SDL-1.2.15.tar > NUL || fail_with SDL-1.2.15.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' libogg-1.3.0.tar > NUL || fail_with libogg-1.3.0.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' libvorbis-1.3.3.tar > NUL || fail_with libvorbis-1.3.3.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' SDL_mixer-1.2.12.tar > NUL || fail_with SDL_mixer-1.2.12.tar - EPIC FAIL
7za x '-oC:\Temp\gcc' vorbis-tools-1.4.0.tar > NUL || fail_with vorbis-tools-1.4.0.tar - EPIC FAIL

patch -d /c/temp/gcc/SDL_mixer-1.2.12 -p1 < SDL_mixer.patch

cd /c/temp/gcc
mkdir dest

mv SDL-1.2.15 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with SDL - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with SDL - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.0 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libogg - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with libogg - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.3 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with libvorbis - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with libvorbis - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv SDL_mixer-1.2.12 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || fail_with SDL_mixer - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with SDL_mixer - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.0 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls || fail_with vorbis-tools - EPIC FAIL
make all install "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with vorbis-tools - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf lib/pkgconfig lib/*.la share
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
