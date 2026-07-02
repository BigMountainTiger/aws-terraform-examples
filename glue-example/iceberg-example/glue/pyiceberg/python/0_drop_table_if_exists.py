from utils import pyiceberg_util

s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/athena'

database_name = "iceberg_example"
table_name = "student"

pyiceberg_util.drop_table_if_exists(s3_athena_output_dir, database_name, table_name)
print(f"Table '{database_name}.{table_name}' dropped")

