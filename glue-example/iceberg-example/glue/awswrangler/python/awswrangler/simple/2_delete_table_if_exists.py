from athena_client import AthenaClient


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'

if __name__ == "__main__":

    athena_client = AthenaClient(s3_athena_output_dir)

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student"

    sql = f"DROP TABLE IF EXISTS {database_name}.{table_name}"

    athena_client.execute_sql_query(sql)

    print(f"Table '{table_name}' deleted from database '{database_name}'")
