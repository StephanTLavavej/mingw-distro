#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' glew-1.11.0.tar > NUL || fail_with glew-1.11.0.tar - EPIC FAIL

patch -d /c/temp/gcc/glew-1.11.0 -p1 < glew.patch
patch -d /c/temp/gcc/glew-1.11.0 -p1 < glew-core.patch

cd /c/temp/gcc
mv glew-1.11.0 src
mkdir dest
cd src
rm include/GL/glxew.h
gcc -s -O3 -Iinclude -c src/glew.c || fail_with glew - EPIC FAIL
ar rs lib/libglew32.a glew.o
mv include lib ../dest
cd /c/temp/gcc
rm -rf src
mv dest glew-1.11.0
cd glew-1.11.0

7z -mx0 a ../glew-1.11.0.7z *
