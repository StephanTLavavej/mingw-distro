#!/bin/sh

source ./0_append_distro_path.sh

untar_file SDL2-2.32.10.tar
untar_file libogg-1.3.6.tar
untar_file libvorbis-1.3.7.tar
untar_file SDL2_mixer-2.8.1.tar
untar_file vorbis-tools-1.4.3.tar

# https://github.com/StephanTLavavej/mingw-distro/issues/118
patch -d $X_WORK_DIR/vorbis-tools-1.4.3 -p1 < vorbis-tools-fix-convert_free_charset.patch

cd $X_WORK_DIR
export PATH=$PATH:/mingw64/bin

mv SDL2-2.32.10 src
mkdir build dest
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DSDL_SHARED=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src

mv libogg-1.3.6 src
mkdir build
cd build

cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DBUILD_SHARED_LIBS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src

mv libvorbis-1.3.7 src
mkdir build
cd build

# Set `CMAKE_POLICY_VERSION_MINIMUM` to work around https://github.com/StephanTLavavej/mingw-distro/issues/113
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DCMAKE_POLICY_VERSION_MINIMUM=4.2.1" \
"-DBUILD_SHARED_LIBS=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src

mv SDL2_mixer-2.8.1 src
mkdir build
cd build

# Disable usage of unavailable libraries.
cmake \
"-DCMAKE_BUILD_TYPE=Release" \
"-DCMAKE_C_FLAGS=-s -O3" \
"-DCMAKE_INSTALL_PREFIX=$X_WORK_DIR/dest" \
"-DBUILD_SHARED_LIBS=OFF" \
"-DSDL2MIXER_MIDI_FLUIDSYNTH=OFF" \
"-DSDL2MIXER_MOD=OFF" \
"-DSDL2MIXER_OPUS=OFF" \
"-DSDL2MIXER_WAVPACK=OFF" \
-G Ninja $X_WORK_DIR/src

ninja
ninja install

cd $X_WORK_DIR
rm -rf build src

mv vorbis-tools-1.4.3 src
mkdir build
cd build

# vorbis-tools currently doesn't support CMake: https://github.com/StephanTLavavej/mingw-distro/issues/114
../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=$X_WORK_DIR/dest --disable-nls

# Compile with -std=gnu17 to work around https://github.com/StephanTLavavej/mingw-distro/issues/116
make $X_MAKE_JOBS all "CFLAGS=-s -O3 -std=gnu17"
make $X_MAKE_JOBS install

cd $X_WORK_DIR
rm -rf build src

mv dest SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
cd SDL+libogg+libvorbis+SDL_mixer+vorbis-tools
rm -rf bin/sdl2-config lib/cmake lib/pkgconfig share

7z -mx0 a ../SDL+libogg+libvorbis+SDL_mixer+vorbis-tools.7z *
