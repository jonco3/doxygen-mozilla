#!/bin/bash

set -eu -o pipefail

if [[ $# -ne 0 ]]; then
    CONFIGS=$@
else
    CONFIGS=configs/*
fi

for TOOL in dot git cmake bison flex; do
    if ! hash $TOOL; then
        echo "Please install required tool '$TOOL'"
        exit
    fi
done

set -x

if [[ ! -e doxygen-src ]]; then
    git clone https://github.com/doxygen/doxygen.git doxygen-src
fi

DOXYGEN=doxygen-build/bin/doxygen

if [[ ! -e $DOXYGEN ]]; then
    mkdir -p doxygen-build
    (
        cd doxygen-build
        cmake -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../doxygen-src
        make clean
        make -j8
    )
fi

if [[ ! -e tree ]]; then
    hg clone http://hg.mozilla.org/mozilla-central ./tree
fi

(
    cd tree
    hg pull --update
)

if [[ -e docs ]]; then
    rm -rf docs
fi
mkdir docs

for CONFIG in $CONFIGS; do
    $DOXYGEN $CONFIG
done

chmod -R 755 docs

echo done
