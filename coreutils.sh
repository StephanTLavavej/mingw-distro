#!/bin/sh

source ./0_append_distro_path.sh

untar_file coreutils-8.28.tar

patch -d /c/temp/gcc/coreutils-8.28 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-8.28 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

cd build

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest

touch src/make-prime-list
make $X_MAKE_JOBS -k "CFLAGS=-O3" "LDFLAGS=-s" || true
cd src
mv sort.exe uniq.exe wc.exe ../../dest/bin
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-8.28
cd coreutils-8.28

7z -mx0 a ../coreutils-8.28.7z *
