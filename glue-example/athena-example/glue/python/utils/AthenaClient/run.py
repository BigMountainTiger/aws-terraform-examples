from athena_client import AthenaClient

database = 'athena_example_database'
bucket = 'athena-example-huge-head-li'
s3_database_dir = f's3://{bucket}/database/{database}'
s3_athena_output_dir = f's3://{bucket}/temp/athena'

if __name__ == "__main__":

    athena_client = AthenaClient(database, s3_athena_output_dir)
    table_name = 'athena_example_table'

    # 0. Clean up the example table if it exists
    athena_client.execute_sql_query(f'DROP TABLE IF EXISTS {database}.{table_name}')

    # 1. Create the example table
    sql_query = f"""
        CREATE EXTERNAL TABLE IF NOT EXISTS {database}.{table_name} (
            id INT,
            name STRING
        )
        STORED AS PARQUET
        LOCATION '{s3_database_dir}/{table_name}/'
    """

    athena_client.execute_sql_query(sql_query)

    # 2. Repair the example table to load partitions
    athena_client.repair_glue_table(table_name)

    # 3. select from the example table
    sql_query = f'SELECT * FROM {database}.{table_name}'
    df = athena_client.read_sql_query(sql_query)

    print(df)

    # 3. Clean up the S3 Athena output directory
    athena_client.clear_s3_athena_output_dir()
