import logging
import boto3
import awswrangler as wr
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
    s3_temp_location = f"s3://{s3_bucket}/temp/"

    create_table_sql = f"""
        CREATE TABLE IF NOT EXISTS {database_name}.{table_name} (
            id INT,
            name STRING
        )
        LOCATION '{s3_table_location}'
        TBLPROPERTIES ( 'table_type' = 'ICEBERG', 'format' = 'PARQUET' )
    """

    print(create_table_sql)

    athena_client = boto3.client("athena")
    response = athena_client.start_query_execution(
        QueryExecutionContext={"Database": database_name, "Catalog": table_name},
        QueryString=create_table_sql,
        ResultConfiguration={
            'OutputLocation': s3_temp_location
        }
    )

    QueryExecutionId = response['QueryExecutionId']
    print(f'Waiting for {QueryExecutionId} to complete')
    query_result = wr.athena.wait_query(QueryExecutionId)
    state = query_result['Status']['State']

    print(f'The query {state}')
