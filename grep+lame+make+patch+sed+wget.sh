#!/bin/sh

# If you're running this by hand, use "MEOW || echo EPIC FAIL" to test MEOW for failure without closing your bash prompt.
# This script uses "MEOW || { echo EPIC FAIL ; exit 1; }" to terminate immediately in the event of failure.

source 0_append_distro_path.sh

7za x '-oC:\Temp\gcc' grep-2.10.tar > NUL || { echo grep-2.10.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' lame-3.99.5.tar > NUL || { echo lame-3.99.5.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' make-3.82.tar > NUL || { echo make-3.82.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' patch-2.6.1.tar > NUL || { echo patch-2.6.1.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' sed-4.2.2.tar > NUL || { echo sed-4.2.2.tar - EPIC FAIL ; exit 1; }
7za x '-oC:\Temp\gcc' wget-1.14.tar > NUL || { echo wget-1.14.tar - EPIC FAIL ; exit 1; }

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch
patch -d /c/temp/gcc/patch-2.6.1 -p1 < patch.patch
patch -d /c/temp/gcc/patch-2.6.1 -p1 < patch-strnlen.patch
patch -d /c/temp/gcc/sed-4.2.2 -p1 < sed.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls || { echo grep - EPIC FAIL ; exit 1; }
make "CFLAGS=-s -Os -fomit-frame-pointer" || { echo grep - EPIC FAIL ; exit 1; }
mv src/grep.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv lame-3.99.5 src
mkdir build
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest || { echo lame - EPIC FAIL ; exit 1; }
make "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" || { echo lame - EPIC FAIL ; exit 1; }
mv frontend/lame.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv make-3.82 src
mkdir build
cd build
# make 3.82 doesn't have a job server on Windows, but 3.83 will.
../src/configure --prefix=/c/temp/gcc/dest --enable-case-insensitive-file-system --disable-job-server --disable-nls --disable-rpath || { echo make - EPIC FAIL ; exit 1; }
sed -e "s/#define PATH_SEPARATOR_CHAR ':'/#define PATH_SEPARATOR_CHAR ';'/" config.h > config.fixed
mv -f config.fixed config.h
make "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" || { echo make - EPIC FAIL ; exit 1; }
mv make.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv patch-2.6.1 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo patch - EPIC FAIL ; exit 1; }
cat << 'EOD' > patch.manifest
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
   <ms_asmv2:trustInfo xmlns:ms_asmv2="urn:schemas-microsoft-com:asm.v2">
      <ms_asmv2:security>
         <ms_asmv2:requestedPrivileges>
            <ms_asmv2:requestedExecutionLevel level="asInvoker" uiAccess="false" />
         </ms_asmv2:requestedPrivileges>
      </ms_asmv2:security>
   </ms_asmv2:trustInfo>
</assembly>
EOD
cat << 'EOD' > patch.rc
1 24 "patch.manifest"
EOD
windres patch.rc patch.rc.o
make "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" "LIBS=/c/temp/gcc/build/patch.rc.o" || { echo patch - EPIC FAIL ; exit 1; }
mv src/patch.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv sed-4.2.2 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || { echo sed - EPIC FAIL ; exit 1; }
make "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" || { echo sed - EPIC FAIL ; exit 1; }
mv sed/sed.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv wget-1.14 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls --without-ssl || { echo wget - EPIC FAIL ; exit 1; }
make "CFLAGS=-Os -fomit-frame-pointer" "LDFLAGS=-s" || { echo wget - EPIC FAIL ; exit 1; }
mv src/wget.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv dest grep+lame+make+patch+sed+wget
cd grep+lame+make+patch+sed+wget
find -name "*.exe" -type f -print -exec strip -s {} ";"

7za -mx0 a ../grep+lame+make+patch+sed+wget.7z *
