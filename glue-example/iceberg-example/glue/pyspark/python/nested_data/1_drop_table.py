import pyspark_utils
from athena_client import AthenaClient

s3_bucket = "iceberg-example-huge-head-li"

database_name = "pyspark_iceberg_example_db"
table_name = "student"

full_table_name = f'{database_name}.{table_name}'
s3_path = f's3://{s3_bucket}/{database_name}/{table_name}/'

s3_athena_output_dir = f's3://{s3_bucket}/athena'

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    def drop_table_pyspark():
        spark.sql(f"DROP TABLE IF EXISTS glue_catalog.{full_table_name}")
        print(f"Table '{table_name}' dropped.")

    def drop_table_by_athena():
        # Need to pip install awswrangler in the docker container
        athena_client = AthenaClient(s3_athena_output_dir)
        athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {full_table_name}")
        print(f"Table '{table_name}' dropped.")

    # Although it works, the spark does not do a clean drop
    # drop_table_pyspark()

    # It looks like Athena does a clean drop including the files
    drop_table_by_athena()
