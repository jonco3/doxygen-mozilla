#!/bin/bash

set -e

[ hash dot ] || {
  echo "Must install 'dot' first from graphviz"
  exit
}

[ -e doxygen-svn ] || {
  svn co https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk doxygen-svn
}

[ -e doxygen-svn/bin/doxygen ] || {
  cd doxygen-svn
  ./configure
  make
}

[ -e tree ] || {
  hg clone ssh://hg.mozilla.org/mozilla-central .
  echo test
}

(
  cd tree
  hg pull
)

pwd
./doxygen-svn/bin/doxygen doxygen.cfg
