import os
from datetime import datetime
from zoneinfo import ZoneInfo
import boto3

target_s3_bucket = os.getenv('target_s3_bucket')

if __name__ == '__main__':
    s3 = boto3.resource('s3')
    bucket = s3.Bucket(target_s3_bucket)

    def clear_bucket():
        bucket.objects.all().delete()

    def upload_file():
        utc_now = datetime.now(tz=ZoneInfo('UTC'))
        now = utc_now.astimezone(ZoneInfo('America/New_York')).strftime('%Y-%m-%d-%H:%M:%S')

        file_name = f'File-{now}.txt'
        bucket.put_object(Key=file_name, Body=f'This file was created at {now}')
        print(f'File {file_name} uploaded to bucket {target_s3_bucket}')


    clear_bucket()
    upload_file() 

