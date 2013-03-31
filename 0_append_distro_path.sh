#!/bin/sh

export PATH=$PATH:/c/mingw/bin

function fail_with {
    echo $*
    if [ "$PS1" == "" ]; then exit 1; fi
}
