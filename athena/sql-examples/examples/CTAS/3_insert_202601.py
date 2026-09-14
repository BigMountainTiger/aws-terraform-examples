import awswrangler as wr
from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
source_table = "ctas_example_source_data"
target_table = "ctas_example_target_data"

mnt = 202601
s3_table_dir = f"s3://{s3_bucket}/{database}/{target_table}"
s3_table_partition_dir = f"{s3_table_dir}/mnt={mnt}"

# Partition columns must be LAST
sql = f"""
    INSERT INTO {database}.{target_table} (id, name, mnt)
    SELECT id, name, mnt
    FROM {database}.{source_table}
    WHERE mnt = {mnt};
"""

client = AthenaClient(f"s3://{s3_bucket}/athena/")
wr.s3.delete_objects(path=s3_table_partition_dir)
client.execute_sql_query(sql=sql)

print('Done')
