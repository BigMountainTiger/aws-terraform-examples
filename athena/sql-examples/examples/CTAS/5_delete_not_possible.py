import awswrangler as wr
from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
target_table = "ctas_example_target_data"

# It is not possible to delete data in an external table
mnt = 202602
sql = f"""
    DELETE FROM {database}.{target_table} WHERE mnt = {mnt};
"""

client = AthenaClient(f"s3://{s3_bucket}/athena/")
client.execute_sql_query(sql=sql)

print('Done')
