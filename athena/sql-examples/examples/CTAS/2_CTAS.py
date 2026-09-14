from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
source_table = "ctas_example_source_data"
target_table = "ctas_example_target_data"

s3_table_dir = f"s3://{s3_bucket}/{database}/{target_table}"

# Partition columns must be LAST
sql = f"""
    CREATE TABLE if not exists {database}.{target_table}
    WITH (
        format = 'PARQUET',
        external_location = '{s3_table_dir}',
        partitioned_by = ARRAY['mnt']
    )
    AS SELECT id, name, mnt
    FROM {database}.{source_table}
    limit 0;
"""


client = AthenaClient(f"s3://{s3_bucket}/athena/")
client.execute_sql_query(sql=sql)

print('Done')