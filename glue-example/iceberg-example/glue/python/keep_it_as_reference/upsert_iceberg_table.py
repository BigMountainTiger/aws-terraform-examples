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

    def clean_up():
        wr.s3.delete_objects(path=s3_temp_table_location)
        wr.catalog.delete_table_if_exists(database=database_name, table=temp_upsert_source)

    try:
        df_new_data = pd.DataFrame({
            'id': [1, 2, 3],
            'name': ['Alice', 'Bob', 'Charlie']
        })

        clean_up()

        wr.s3.to_parquet(
            df=df_new_data,
            path=s3_temp_table_location,
            index=False,
            dataset=True,
            database=database_name,
            table=temp_upsert_source
        )

        merge_sql = f"""
            MERGE INTO {database_name}.{table_name} AS target
            USING {database_name}.{temp_upsert_source} AS source ON target.id = source.id
            WHEN MATCHED THEN UPDATE SET name = source.name
            WHEN NOT MATCHED THEN INSERT (id, name) VALUES (source.id, source.name)
        """

        print(merge_sql)

        athena_client = boto3.client("athena")
        response = athena_client.start_query_execution(
            QueryExecutionContext={"Database": database_name},
            QueryString=merge_sql,
            ResultConfiguration={
                'OutputLocation': s3_temp_location
            }
        )

        QueryExecutionId = response['QueryExecutionId']
        print(f'Waiting for {QueryExecutionId} to complete')
        wr.athena.wait_query(QueryExecutionId)

    finally:
        clean_up()
        pass
