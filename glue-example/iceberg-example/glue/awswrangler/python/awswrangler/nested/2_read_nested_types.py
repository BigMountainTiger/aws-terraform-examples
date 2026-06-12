import io
import json
from athena_client import AthenaClient
import awswrangler as wr
import pandas as pd


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    athena_client = AthenaClient(s3_athena_output_dir)

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student_nested"

    sql = f'SELECT * FROM {database_name}.{table_name}'
    df = athena_client.read_sql_query(sql=sql).convert_dtypes()

    print(df)
