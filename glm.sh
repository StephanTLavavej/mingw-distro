#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' glm-0.9.5.4.7z glm/glm > NUL || fail_with glm-0.9.5.4.7z - EPIC FAIL

cd /c/temp/gcc
mv glm glm-0.9.5.4
cd glm-0.9.5.4
mkdir include
mv glm include

7z -mx0 a ../glm-0.9.5.4.7z *
