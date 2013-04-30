#!/bin/bash

set -e

[ -e doxygen-svn ] || {
  svn co https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk doxygen-svn
}

cd doxygen-svn
./configure
make
