import boto3
import datetime


def run():
    BUCKET_NAME = "example.huge.head.li"
    key = f'F-{datetime.datetime.now().strftime("%Y-%m-%dT%H-%M-%SZ")}'

    client = boto3.client('s3')
    client.put_object(Body=b'Some Text', Bucket=BUCKET_NAME, Key=key)

    print('Done')


run()
