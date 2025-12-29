import boto3


def s3_object_exists(bucket, key):
    s3 = boto3.client('s3')
    try:
        s3.head_object(Bucket=bucket, Key=key)
        return True
    except s3.exceptions.ClientError as e:
        if e.response['Error']['Code'] == '404':
            return False
        else:
            raise e


def validate(bucket, key):
    print()
    print(bucket)
    print(key)

    if s3_object_exists(bucket, key):
        print(f'Exist')
    else:
        print(f'Not exist')


bucket = 's3-boto3-example-huge-head-li'
key = 'synced-files/example-file.txt'
validate(bucket, key)

bucket = 's3-boto3-example-huge-head-li'
key = 'synced-files/non-exist-file.txt'
validate(bucket, key)

bucket = 'Non-Existent-Bucket'
key = 'synced-files/example-file.txt'
validate(bucket, key)
