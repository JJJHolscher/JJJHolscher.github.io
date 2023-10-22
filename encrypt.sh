#! /bin/sh

rm -rf docs
staticrypt test/qry/* -rd test/sec
mkdir docs
cp -r test/* docs
cp CNAME docs/CNAME

