import os
import logging
import json
import datetime
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambdaHandler(event, context):

    SECRET_NAME = os.environ['SECRET_NAME']
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(response['SecretString'])

    logger.info(secret)

    # bucket = 'kms-example-bucket-huge-head-li'
    # t = datetime.datetime.now(datetime.timezone.utc).isoformat()

    # s3 = boto3.resource('s3')
    # object = s3.Object(bucket, f'events/events-{t}.json')
    # object.put(Body=t.encode('utf-8'))

    # print('Uploaded to s3')

    # result = {
    #     "value": "OK"
    # }

    return secret
