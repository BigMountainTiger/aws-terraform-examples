import boto3

s3 = boto3.resource('s3')

if __name__ == '__main__':
    for bucket in s3.buckets.all():
        print(bucket.name)
