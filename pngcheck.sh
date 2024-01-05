#!/bin/sh

source ./0_append_distro_path.sh

untar_file pngcheck-3.0.3.tar

cd $X_WORK_DIR
mv pngcheck-3.0.3 src
mkdir -p dest/bin

gcc -s -O3 src/pngcheck.c -o dest/bin/pngcheck.exe
rm -rf src
mv dest pngcheck-3.0.3
cd pngcheck-3.0.3

7z -mx0 a ../pngcheck-3.0.3.7z *
