import logging
import boto3
import awswrangler as wr
import pandas as pd

logging.basicConfig(level=logging.INFO)
log = logging.getLogger()

log.info('Configured the logger')

s3_bucket = 'iceberg-example-huge-head-li'
s3_athena_workspace = f's3://{s3_bucket}/athena/'
database_name = 'iceberg_example'

class AthenaClient:
    def __init__(self, output_location, database_name):
        self.output_location = output_location
        self.database_name = database_name

    def run(self, sql):
        client = boto3.client("athena")
        response = client.start_query_execution(
            QueryExecutionContext={"Database": self.database_name},
            QueryString=sql,
            ResultConfiguration={
                'OutputLocation': self.output_location
            }
        )

        QueryExecutionId = response['QueryExecutionId']
        result = wr.athena.wait_query(QueryExecutionId)
        state = result['Status']['State']

        if state != 'SUCCEEDED':
            raise Exception(f'The execution {QueryExecutionId} state is {state}, SUCCEEDED is expected')

        return state

table_name = 'parquet_table'
table_s3_location = f's3://{s3_bucket}/{database_name}/{table_name}'

if __name__ == '__main__':
    
    snapshot = 2
    snapshot_location = f'{table_s3_location}/snapshot={snapshot}/snapshot_{snapshot}.parquet'

    df = pd.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })

    df.to_parquet(snapshot_location, engine='pyarrow', index=False)

    athena_client = AthenaClient(s3_athena_workspace, database_name)
    status = athena_client.run(f'MSCK REPAIR TABLE {table_name};')
    print(status)