#! /bin/sh

rm -rf docs
staticrypt test/qry/* -rd test/qry
mkdir docs
cp -r test/* docs
cp CNAME docs/CNAME

