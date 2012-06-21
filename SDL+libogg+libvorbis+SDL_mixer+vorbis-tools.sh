#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' SDL-1.2.15.tar > NUL || { echo SDL-1.2.15.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' libogg-1.3.0.tar > NUL || { echo libogg-1.3.0.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' libvorbis-1.3.3.tar > NUL || { echo libvorbis-1.3.3.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' SDL_mixer-1.2.12.tar > NUL || { echo SDL_mixer-1.2.12.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' vorbis-tools-1.4.0.tar > NUL || { echo vorbis-tools-1.4.0.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/SDL_mixer-1.2.12 -p1 < SDL_mixer.patch

cd /c/temp/gcc
mkdir dest

mv SDL-1.2.15 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo SDL - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo SDL - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv libogg-1.3.0 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || { echo libogg - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo libogg - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv libvorbis-1.3.3 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || { echo libvorbis - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo libvorbis - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv SDL_mixer-1.2.12 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-shared || { echo SDL_mixer - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo SDL_mixer - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv vorbis-tools-1.4.0 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls || { echo vorbis-tools - EPIC FAIL ; exit 1; }
make all install "CFLAGS=-s -Os -fomit-frame-pointer" || { echo vorbis-tools - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf lib/pkgconfig lib/*.la share
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
