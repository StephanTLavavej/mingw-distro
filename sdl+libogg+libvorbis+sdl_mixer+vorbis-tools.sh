#!/bin/sh

source ./0_append_distro_path.sh

untar_file SDL2-2.0.6.tar
untar_file libogg-1.3.2.tar
untar_file libvorbis-1.3.5.tar
untar_file SDL2_mixer-2.0.1.tar --exclude=SDL2_mixer-2.0.1/Xcode
untar_file vorbis-tools-1.4.0.tar

patch -d /c/temp/gcc/SDL2-2.0.6 -p1 < sdl-clipcursor.patch

cd /c/temp/gcc

mv SDL2-2.0.6 src
mkdir build dest
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make install
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.2 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make install
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.5 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make install
cd /c/temp/gcc
rm -rf build src

mv SDL2_mixer-2.0.1 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-shared

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make install
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.0 src
mkdir build
cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest --disable-nls

make $X_MAKE_JOBS all "CFLAGS=-s -O3"
make install
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf bin/sdl2-config lib/cmake lib/pkgconfig lib/*.la share
for i in bin/*.exe; do mv $i ${i/x86_64-w64-mingw32-}; done

7z -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
