import boto3

file_name = './python/file/example.csv'

bucket = 's3-sync-example-huge-head-li'
object_key = 'database/example.csv'

if __name__ == '__main__':
    s3_client = boto3.client('s3')
    s3_client.upload_file(file_name, bucket, object_key)

    print('Done')