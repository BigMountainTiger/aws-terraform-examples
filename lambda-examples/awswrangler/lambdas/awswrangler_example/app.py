import os
import awswrangler as wr
import pandas as pd
import json


def lambda_handler(event, context):

    S3_BUCKET = os.environ['S3_BUCKET']
    csv_path = f's3://{S3_BUCKET}/example.csv'

    df = pd.DataFrame({
        'id': [1, 2, 3, 4],
        'name': ['Alice', 'Bob', 'Charlie | " D', '"'],
        'age': [25, 30, 35, 40]
    })

    df = df.convert_dtypes()
    df.to_csv(csv_path, sep='|', index=False)


    df = pd.read_csv(csv_path, sep='|')
    print(df)

    return {
        'statusCode': 200,
        'body': S3_BUCKET
    }
