#!/bin/sh

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' coreutils-8.20.tar > NUL || fail_with coreutils-8.20.tar - EPIC FAIL

patch -d /c/temp/gcc/coreutils-8.20 -p1 < coreutils.patch

cd /c/temp/gcc
mv coreutils-8.20 src
mkdir -p build dest/bin

# Missing <sys/wait.h>.
echo "/* ignore */" > src/lib/savewd.c

# Missing <pwd.h> and <grp.h>.
echo "/* ignore */" > src/lib/idcache.c
echo "/* ignore */" > src/lib/userspec.c

cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with coreutils - EPIC FAIL
touch src/make-prime-list
make -k "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s"
cd src
mv sha1sum.exe sha256sum.exe sha512sum.exe sort.exe uniq.exe wc.exe ../../dest/bin || fail_with coreutils - EPIC FAIL
cd /c/temp/gcc
rm -rf build src
mv dest coreutils-8.20
cd coreutils-8.20
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../coreutils-8.20.7z *
