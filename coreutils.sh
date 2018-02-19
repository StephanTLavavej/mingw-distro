#!/bin/sh

source ./0_append_distro_path.sh

untar_file coreutils-8.29.tar

patch -d /c/temp/gcc/coreutils-8.29 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-8.29 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

cd build
echo "ac_cv_header_pthread_h=no" > config.site
export CONFIG_SITE=/c/temp/gcc/build/config.site

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest

touch src/make-prime-list
make $X_MAKE_JOBS -k "CFLAGS=-O3" "LDFLAGS=-s" || true
cd src
mv sort.exe uniq.exe wc.exe ../../dest/bin
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-8.29
cd coreutils-8.29

7z -mx0 a ../coreutils-8.29.7z *
