from utils.athena_client import AthenaClient

s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/athena'

database_name = "iceberg_example"
table_name = "student"

def drop_table_if_exists(s3_athena_output_dir, database_name, table_name):
    athena_client = AthenaClient(s3_athena_output_dir=s3_athena_output_dir)
    athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {database_name}.{table_name};")

drop_table_if_exists(s3_athena_output_dir, database_name, table_name)
print(f"Table '{database_name}.{table_name}' dropped")

