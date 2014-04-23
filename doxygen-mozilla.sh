#!/bin/bash

set -e

hash dot || {
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
  hg update
)

#./doxygen-svn/bin/doxygen doxygen.cfg
#scp -r docs/html people.mozilla.org:public_html/doxygen

for f in configs/*
do
  [ -e out ] && {
    rm -rf out
  }
  mkdir out
  ./doxygen-svn/bin/doxygen $f
  chmod -R 755 out/docs/html
  (
    cd out/docs/html
    tar cfv - . | ssh people.mozilla.org -C "mkdir public_html/doxygen/$(basename $f); tar -xvf - -C public_html/doxygen/$(basename $f); chmod -R 755 public_html/doxygen/$(basename $f)"
  )
done
