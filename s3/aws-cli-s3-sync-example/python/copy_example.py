import boto3

bucket = 's3-sync-example-huge-head-li'
source_object_key = 'database/example.csv'
target_object_key = 'database/example/mnt=202512/example-202512.csv'

if __name__ == '__main__':
    s3_client = boto3.client('s3')
    s3_client.copy_object(
        CopySource={'Bucket': bucket, 'Key': source_object_key},
        Bucket=bucket,
        Key=target_object_key
    )

    print('Done')
