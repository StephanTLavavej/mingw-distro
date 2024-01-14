#!/bin/sh

source ./0_append_distro_path.sh

# https://github.com/uutils/coreutils
untar_file coreutils-0.0.23.tar

cd $X_WORK_DIR
mv coreutils-0.0.23 src
mkdir dest
cd src

export PATH=$PATH:/clang64/bin
cargo install --path . --locked --root $X_WORK_DIR/dest

cd $X_WORK_DIR
rm -rf src
mv dest uutils-coreutils-0.0.23
cd uutils-coreutils-0.0.23
rm -rf .crates.toml .crates2.json

7z -mx0 a ../uutils-coreutils-0.0.23.7z *
