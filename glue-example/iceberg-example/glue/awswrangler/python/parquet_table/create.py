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


def create_table(table_name):
    table_s3_location = f's3://{s3_bucket}/{database_name}/{table_name}'

    sql_column_list = [
        "id int",
        "name string"
    ]
    create_table_sql = f"""
        CREATE external TABLE IF NOT EXISTS {database_name}.{table_name} ({', '.join(sql_column_list)})
        PARTITIONED BY (snapshot string)
        STORED AS PARQUET
        LOCATION '{table_s3_location}'
    """

    print(create_table_sql)

    athena_client = AthenaClient(s3_athena_workspace, database_name)

    status = athena_client.run(create_table_sql)
    print(status)

    status = athena_client.run(f'MSCK REPAIR TABLE {table_name};')
    print(status)


if __name__ == '__main__':
    create_table('parquet_table')
