#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' glm-0.9.4.4.zip glm-0.9.4.4/glm > NUL || fail_with glm-0.9.4.4.zip - EPIC FAIL

cd /c/temp/gcc/glm-0.9.4.4
mkdir include
mv glm include

7za -mx0 a ../glm-0.9.4.4.7z *
