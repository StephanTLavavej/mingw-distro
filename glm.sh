#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' glm-0.9.4.5.zip glm/glm > NUL || fail_with glm-0.9.4.5.zip - EPIC FAIL

cd /c/temp/gcc
mv glm glm-0.9.4.5
cd glm-0.9.4.5
mkdir include
mv glm include

7z -mx0 a ../glm-0.9.4.5.7z *
