#!/bin/sh

source ./0_append_distro_path.sh

extract_file make-4.2.1.tar

cd /c/temp/gcc
mkdir -p dest/bin

mv make-4.2.1 src
cd src
cmd /c "build_w32.bat gcc"
strip -s GccRel/gnumake.exe || fail_with make 1 - EPIC FAIL
mv GccRel/gnumake.exe ../dest/bin/make.exe || fail_with make 2 - EPIC FAIL
# mingw32-make.exe is for CMake.
cp ../dest/bin/make.exe ../dest/bin/mingw32-make.exe || fail_with make 3 - EPIC FAIL
cd /c/temp/gcc
rm -rf src

mv dest make-4.2.1
cd make-4.2.1

7z -mx0 a ../make-4.2.1.7z *
