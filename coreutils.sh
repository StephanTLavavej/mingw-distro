#!/bin/sh

source ./0_append_distro_path.sh

extract_file coreutils-8.26.tar

patch -d /c/temp/gcc/coreutils-8.26 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-8.26 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest || fail_with coreutils 1 - EPIC FAIL

touch src/make-prime-list
make $X_MAKE_JOBS -k "CFLAGS=-O3" "LDFLAGS=-s"
cd src
mv sort.exe uniq.exe wc.exe ../../dest/bin || fail_with coreutils 2 - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-8.26
cd coreutils-8.26

7z -mx0 a ../coreutils-8.26.7z *
