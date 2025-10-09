import logging
import json
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
    s3_temp_location = f"s3://{s3_bucket}/temp"

    sql = f"""
        delete from {database_name}.{table_name}
    """

    athena_client = boto3.client("athena")
    response = athena_client.start_query_execution(
        QueryExecutionContext={"Database": database_name},
        QueryString=sql,
        ResultConfiguration={
            'OutputLocation': s3_temp_location
        }
    )

    QueryExecutionId = response['QueryExecutionId']
    wr.athena.wait_query(QueryExecutionId)