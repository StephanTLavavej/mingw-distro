#!/bin/sh

source ./0_append_distro_path.sh

untar_file coreutils-9.0.tar

patch -d /c/temp/gcc/coreutils-9.0 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-9.0 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

# Missing fpathconf().
echo "/* ignore */" > src/lib/backupfile.c

cd build
echo "ac_cv_header_pthread_h=no" > config.site
export CONFIG_SITE=/c/temp/gcc/build/config.site

../src/configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --target=x86_64-w64-mingw32 \
--prefix=/c/temp/gcc/dest

touch src/make-prime-list
# -D_FORTIFY_SOURCE=0 works around https://github.com/StephanTLavavej/mingw-distro/issues/71
# -lbcrypt provides BCryptGenRandom
make $X_MAKE_JOBS -k "CFLAGS=-O3 -D_FORTIFY_SOURCE=0" "LDFLAGS=-s" "LIBS=-lbcrypt" || true
cd src
mv sort.exe uniq.exe wc.exe ../../dest/bin
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-9.0
cd coreutils-9.0

7z -mx0 a ../coreutils-9.0.7z *
