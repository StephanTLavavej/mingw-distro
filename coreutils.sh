#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' coreutils-8.15.tar > NUL || { echo coreutils-8.15.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/coreutils-8.15 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-8.15 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo coreutils - EPIC FAIL ; exit 1; }
make -k "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s"
cd src
mv sha1sum.exe sha256sum.exe sha512sum.exe sort.exe uniq.exe wc.exe ../../dest/bin || { echo coreutils - EPIC FAIL ; exit 1; }
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-8.15
cd coreutils-8.15
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../coreutils-8.15.7z *
