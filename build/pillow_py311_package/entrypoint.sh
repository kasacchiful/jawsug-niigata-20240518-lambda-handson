#!/bin/bash -eu

SRC=/python
DIST=/dist/package.zip
TMP=/package

python3 -m pip install -t ${SRC} $@
rm -f ${DIST}
rm -rf ${TMP}
mkdir ${TMP}
cd ${SRC}
cp -r ./* ${TMP}
cd ${TMP}
zip -q -r ${DIST} .
cd /dist
zip -q ${DIST} lambda_function.py
