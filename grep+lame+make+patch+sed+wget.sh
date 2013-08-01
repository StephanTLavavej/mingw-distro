#!/bin/sh

source 0_append_distro_path.sh

7z x '-oC:\Temp\gcc' grep-2.10.tar > NUL || fail_with grep-2.10.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' lame-3.99.5.tar > NUL || fail_with lame-3.99.5.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' make-3.82.tar > NUL || fail_with make-3.82.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' patch-2.6.1.tar > NUL || fail_with patch-2.6.1.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' sed-4.2.2.tar > NUL || fail_with sed-4.2.2.tar - EPIC FAIL
7z x '-oC:\Temp\gcc' wget-1.14.tar > NUL || fail_with wget-1.14.tar - EPIC FAIL

patch -d /c/temp/gcc/grep-2.10 -p1 < grep.patch
patch -d /c/temp/gcc/patch-2.6.1 -p1 < patch.patch
patch -d /c/temp/gcc/patch-2.6.1 -p1 < patch-strnlen.patch
patch -d /c/temp/gcc/sed-4.2.2 -p1 < sed.patch

cd /c/temp/gcc
mkdir -p dest/bin

mv grep-2.10 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls || fail_with grep - EPIC FAIL
make "CFLAGS=-s -O3 -fomit-frame-pointer" || fail_with grep - EPIC FAIL
mv src/grep.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv lame-3.99.5 src
mkdir build
cd build
../src/configure --disable-shared --prefix=/c/temp/gcc/dest || fail_with lame - EPIC FAIL
make "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with lame - EPIC FAIL
mv frontend/lame.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv make-3.82 src
mkdir build
cd build
# make 3.82 doesn't have a job server on Windows, but 3.83 will.
../src/configure --prefix=/c/temp/gcc/dest --enable-case-insensitive-file-system --disable-job-server --disable-nls --disable-rpath || fail_with make - EPIC FAIL
sed -e "s/#define PATH_SEPARATOR_CHAR ':'/#define PATH_SEPARATOR_CHAR ';'/" config.h > config.fixed
mv -f config.fixed config.h
make "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with make - EPIC FAIL
mv make.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv patch-2.6.1 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with patch - EPIC FAIL
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
make "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" "LIBS=/c/temp/gcc/build/patch.rc.o" || fail_with patch - EPIC FAIL
mv src/patch.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv sed-4.2.2 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest || fail_with sed - EPIC FAIL
make "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with sed - EPIC FAIL
mv sed/sed.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv wget-1.14 src
mkdir build
cd build
../src/configure --prefix=/c/temp/gcc/dest --disable-nls --without-ssl || fail_with wget - EPIC FAIL
make "CFLAGS=-O3 -fomit-frame-pointer" "LDFLAGS=-s" || fail_with wget - EPIC FAIL
mv src/wget.exe ../dest/bin
cd /c/temp/gcc
rm -rf build src

mv dest grep+lame+make+patch+sed+wget
cd grep+lame+make+patch+sed+wget
find -name "*.exe" -type f -print -exec strip -s {} ";"

7z -mx0 a ../grep+lame+make+patch+sed+wget.7z *
