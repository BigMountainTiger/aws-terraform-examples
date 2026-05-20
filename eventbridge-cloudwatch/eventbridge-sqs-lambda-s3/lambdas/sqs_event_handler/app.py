import datetime
import boto3
import json
import awswrangler as wr
import pandas as pd


# def lambdaHandler(event, context):

#     Records = event['Records']
#     data = []
#     for record in Records:
#         record = json.loads(record['body'])
#         data.append(record)

#     print(data)
#     df = pd.DataFrame.from_dict(data)

#     t = datetime.datetime.now(datetime.timezone.utc).isoformat()

#     print(t)
#     print(df)

#     bucket = 'example-bucket-huge-head-li'
#     wr.s3.to_parquet(df=df, path=f's3://{bucket}/pq/T-{t}.parquet', index=False)

#     print('Uploaded to s3')

def lambdaHandler(event, context):

    Records = event['Records']
    result = ''
    for record in Records:
        result = f'{result}{record['body']}\n'

    t = datetime.datetime.now(datetime.timezone.utc).isoformat()

    bucket = 'example-bucket-huge-head-li'

    # client = boto3.client('s3')
    # client.put_object(Body=result.encode('utf-8'), Bucket=bucket,
    #                   Key=f'events/events-{t}.json')

    s3 = boto3.resource('s3')
    object = s3.Object(bucket, f'events/events-{t}.json')
    object.put(Body=result.encode('utf-8'))

    print('Uploaded to s3')
