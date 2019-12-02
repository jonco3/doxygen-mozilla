#!/bin/bash

set -euf -o pipefail

for TOOL in dot git cmake bison; do
    if ! hash $TOOL; then
        echo "Please install required tool '$TOOL'"
        exit
    fi
done

set -x

if [[ ! -e doxygen ]]; then
    git clone https://github.com/doxygen/doxygen.git doxygen
fi

DOXYGEN=doxygen/build/bin/doxygen

echo $PATH
export PATH

if [[ ! -e $DOXYGEN ]]; then
    cd doxygen
    mkdir -p build
    cd build
    cmake -G "Unix Makefiles" ..
    make clean
    make
fi


if [[ ! -e tree ]]; then
    hg clone http://hg.mozilla.org/mozilla-central ./tree
fi

(
    cd tree
    hg pull --update
)

#$DOXYGEN doxygen.cfg

if [[ -e out ]]; then
    rm -rf out
fi

mkdir out

for CONFIG in configs/*; do
    $DOXYGEN $CONFIG
done

chmod -R 755 out/docs/html

echo done
