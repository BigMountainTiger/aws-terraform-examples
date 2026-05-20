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

    sql = f"""
        select * from {database_name}.{table_name}
    """

    df = wr.athena.read_sql_query(database=database_name, sql=sql)

    print(df.head())
