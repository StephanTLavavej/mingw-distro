#!/bin/sh

source ./0_append_distro_path.sh

# Work around https://github.com/msys2/MSYS2-packages/issues/1216 by excluding the affected symlink.
untar_file ripgrep-15.1.0.tar --exclude=ripgrep-15.1.0/HomebrewFormula

cd $X_WORK_DIR
mv ripgrep-15.1.0 src
mkdir dest
cd src

export PATH=$PATH:/clang64/bin
# Link to the CRT statically in order to avoid "The code execution cannot proceed because libunwind.dll was not found."
export RUSTFLAGS="-Ctarget-feature=+crt-static"
cargo install --profile release-lto --features 'pcre2' --path . --locked --root $X_WORK_DIR/dest

cd $X_WORK_DIR
rm -rf src
mv dest ripgrep-15.1.0
cd ripgrep-15.1.0
rm -rf .crates.toml .crates2.json

7z -mx0 a ../ripgrep-15.1.0.7z *
