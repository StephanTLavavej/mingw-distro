#!/bin/sh

source ./0_append_distro_path.sh

7z x '-oC:\Temp\gcc' SDL2-2.0.3.tar > /dev/null || fail_with SDL2-2.0.3.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' libogg-1.3.2.tar > /dev/null || fail_with libogg-1.3.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' libvorbis-1.3.5.tar > /dev/null || fail_with libvorbis-1.3.5.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' SDL2_mixer-2.0.0.tar > /dev/null || fail_with SDL2_mixer-2.0.0.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' vorbis-tools-1.4.0.tar > /dev/null || fail_with vorbis-tools-1.4.0.tar - EPIC FAIL

patch -d /c/temp/gcc/SDL2-2.0.3 -p1 < sdl-clipcursor.patch

cd /c/temp/gcc

mv SDL2-2.0.3 src
mkdir build dest
cd build
sed -re "s/ -XCClinker -static-libgcc//" ../src/configure > configure-fixed
mv -f configure-fixed ../src/configure
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared --disable-render-d3d || fail_with SDL - EPIC FAIL
make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with SDL - EPIC FAIL
make install || fail_with SDL - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.2 src
mkdir build
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared || fail_with libogg - EPIC FAIL
make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with libogg - EPIC FAIL
make install || fail_with libogg - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.5 src
mkdir build
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared || fail_with libvorbis - EPIC FAIL
make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with libvorbis - EPIC FAIL
make install || fail_with libvorbis - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv SDL2_mixer-2.0.0 src
mkdir build
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-shared || fail_with SDL_mixer - EPIC FAIL
make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with SDL_mixer - EPIC FAIL
make install || fail_with SDL_mixer - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.0 src
mkdir build
cd build
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 --prefix=/c/temp/gcc/dest --disable-nls || fail_with vorbis-tools - EPIC FAIL
make $X_MAKE_JOBS all "CFLAGS=-s -O3" || fail_with vorbis-tools - EPIC FAIL
make install || fail_with vorbis-tools - EPIC FAIL
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf bin/sdl2-config lib/pkgconfig lib/*.la share
for i in bin/*.exe; do mv $i ${i/x86_64-w64-mingw32-}; done

7z -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
