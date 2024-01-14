#!/bin/sh

# Idempotency.
if [[ -v X_DISTRO_ROOT ]]; then return; fi

# Reject expansion of unset variables.
set -u

# Exit when a command fails.
if [ "${PS1:-}" == "" ]; then set -e; fi

export X_DISTRO_ROOT=/c/mingw

export X_DISTRO_BIN=$X_DISTRO_ROOT/bin
export X_DISTRO_INC=$X_DISTRO_ROOT/include
export X_DISTRO_LIB=$X_DISTRO_ROOT/lib

export X_WORK_DIR=/e/temp/gcc

export PATH=$PATH:$X_DISTRO_BIN

export C_INCLUDE_PATH=$X_DISTRO_INC
export CPLUS_INCLUDE_PATH=$X_DISTRO_INC

function untar_file {
    tar --extract --directory=$X_WORK_DIR --file=$*
}

export X_MAKE_JOBS="-j$NUMBER_OF_PROCESSORS -O"
export X_B2_JOBS="-j$NUMBER_OF_PROCESSORS"

# Print commands.
if [ "${PS1:-}" == "" ]; then set -x; fi
