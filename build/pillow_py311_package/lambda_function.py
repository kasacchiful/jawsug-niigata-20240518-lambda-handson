from PIL import Image
import boto3
import urllib.parse
import os
import json

DST_BUCKET = os.environ['DST_BUCKET']
MAX_WIDTH  = os.environ.get('MAX_WIDTH', 100)
MAX_HEIGHT = os.environ.get('MAX_HEIGHT', 100)

def lambda_handler(event, context):
    src_bucket = event['Records'][0]['s3']['bucket']['name']
    src_key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')

    dst_bucket = DST_BUCKET
    splitext = os.path.splitext(src_key)
    dst_key = '{}_thumb{}'.format(splitext[0], splitext[1])

    tmp = '/tmp/' + os.path.basename(src_key)

    s3 = boto3.client('s3')
    try:
        s3.download_file(Bucket=src_bucket, Key=src_key, Filename=tmp)
        img = Image.open(tmp)
        img.thumbnail((MAX_WIDTH, MAX_HEIGHT), Image.LANCZOS)
        img.save(tmp)
        s3.upload_file(Filename=tmp, Bucket=dst_bucket, Key=dst_key)
        ret = {
            'statusCode': 200,
            'body': json.dumps({'message': 'create thumbnail: {0}/{1}'.format(dst_bucket, dst_key)})
        }
        return ret
    except Exception as e:
        print(e)
        raise e
