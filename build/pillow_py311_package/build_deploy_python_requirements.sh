#!/bin/bash

rm -rf build.zip
docker build . -t bundle-pip-modules-for-aws-lambda-layers:python3.11
docker run --rm \
    -v $(pwd)/requirements.txt:/requirements.txt \
    -v $(pwd):/dist \
    bundle-pip-modules-for-aws-lambda-layers:python3.11 \
        -r requirements.txt
