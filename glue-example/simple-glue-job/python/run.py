import boto3
import datetime

from pkg1 import module1

def run():
    BUCKET_NAME = "example.huge.head.li.2023"
    key = f'glue-job-example/F-{datetime.datetime.now().strftime("%Y-%m-%dT%H-%M-%SZ")}'

    client = boto3.client('s3')

    txt = module1.get_text()
    client.put_object(Body=txt.encode("utf-8"), Bucket=BUCKET_NAME, Key=key)

    print('Done')


run()
