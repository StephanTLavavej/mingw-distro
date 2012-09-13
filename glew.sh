#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' glew-1.9.0.tar > NUL || { echo glew-1.9.0.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/glew-1.9.0 -p1 < glew.patch

cd /c/temp/gcc
mv glew-1.9.0 src
mkdir dest
cd src
rm include/GL/glxew.h
gcc -s -Os -fomit-frame-pointer -Iinclude -c src/glew.c || { echo glew - EPIC FAIL ; exit 1; }
ar rs lib/libglew32.a glew.o
mv include lib ../dest
cd /c/temp/gcc
rm -rf src
mv dest glew-1.9.0
cd glew-1.9.0

7za -mx0 a ../glew-1.9.0.7z *
