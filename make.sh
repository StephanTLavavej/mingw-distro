#!/bin/sh

source ./0_append_distro_path.sh

untar_file make-4.3.tar

cd $X_WORK_DIR
mkdir -p dest/bin

mv make-4.3 src
cd src
# " /c" works around https://github.com/msys2/MSYS2-packages/issues/1606
cmd " /c" "build_w32.bat" "gcc"
strip -s GccRel/gnumake.exe
mv GccRel/gnumake.exe ../dest/bin/make.exe
# mingw32-make.exe is for CMake.
cp ../dest/bin/make.exe ../dest/bin/mingw32-make.exe
cd $X_WORK_DIR
rm -rf src

mv dest make-4.3
cd make-4.3

7z -mx0 a ../make-4.3.7z *
