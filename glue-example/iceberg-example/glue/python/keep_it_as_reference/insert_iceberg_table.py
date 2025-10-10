import logging
import sys
import boto3
import awswrangler as wr
import pandas as pd
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue import DynamicFrame

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

sc = SparkContext.getOrCreate()
sc.setLogLevel('ERROR')

glueContext = GlueContext(sc)
spark = glueContext.spark_session


if __name__ == '__main__':

    database_name = 'iceberg_example'
    table_name = 'iceberg_table'

    s3_bucket = 'iceberg-example-huge-head-li'
    s3_table_location = f"s3://{s3_bucket}/iceberg_example/{table_name}/"
    s3_temp_location = f"s3://{s3_bucket}/temp"

    temp_upsert_source = 'temp_upsert_source'
    s3_temp_table_location = f"{s3_temp_location}/{temp_upsert_source}"

    sql = f"""
        insert into {database_name}.{table_name} values(1, 'Song');
    """

    print(sql)

    athena_client = boto3.client("athena")
    response = athena_client.start_query_execution(
        QueryExecutionContext={"Database": database_name},
        QueryString=sql,
        ResultConfiguration={
            'OutputLocation': s3_temp_location
        }
    )

    QueryExecutionId = response['QueryExecutionId']
    print(f'Waiting for {QueryExecutionId} to complete')
    result = wr.athena.wait_query(QueryExecutionId)
    state = result['Status']['State']

    print(state)

    sql = f"""
        select * from {database_name}.{table_name}
    """

    df = wr.athena.read_sql_query(database=database_name, sql=sql)

    print(df.head())
    df.info()