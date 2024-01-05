#!/bin/sh

source ./0_append_distro_path.sh

untar_file glm-0.9.9.8.tar

cd $X_WORK_DIR
mv glm-0.9.9.8 src
mkdir -p dest/include
mv src/glm dest/include
rm -rf src
mv dest glm-0.9.9.8
cd glm-0.9.9.8

7z -mx0 a ../glm-0.9.9.8.7z *
