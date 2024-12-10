import os
import json
import boto3


def lambda_handler(event, context):

    SECRET_NAME = os.environ['SECRET_NAME']
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=SECRET_NAME)
    secret = json.loads(response['SecretString'])

    print(secret)

    print(event)
    records = event['Records']

    print(records)
