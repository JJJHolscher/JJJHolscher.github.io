#! /bin/sh

staticrypt test/qry/* -rd test/qry
rm -r docs || mkdir docs
cp -r test docs

