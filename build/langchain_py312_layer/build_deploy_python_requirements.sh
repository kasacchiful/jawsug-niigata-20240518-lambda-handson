#!/bin/bash
if [ $# -ne 1 ]; then
  echo "指定された引数は$#個です。" 1>&2
  echo "実行するには1個の引数が必要です。" 1>&2
  echo "$0 [AWS CLI Profile]"
  exit 1
fi
Profile=$1
export AWS_PAGER=""
export AWS_PROFILE=$Profile
rm -rf layer.zip
docker build . -t bundle-pip-modules-for-aws-lambda-layers:python3.12
docker run --rm \
    -v $(pwd)/requirements.txt:/requirements.txt \
    -v $(pwd):/dist \
    bundle-pip-modules-for-aws-lambda-layers:python3.12 \
        -r requirements.txt
aws s3 cp ./layer.zip s3://lambda-layer-deploy-bucket-kas/layer/langchain-py312-layer.zip
aws lambda publish-layer-version \
    --layer-name langchain-py312-layer \
    --compatible-runtimes python3.12 \
    --content S3Bucket=lambda-layer-deploy-bucket-kas,S3Key=layer/langchain-py312-layer.zip \
