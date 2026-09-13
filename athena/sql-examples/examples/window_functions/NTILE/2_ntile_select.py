from athena_client import AthenaClient

s3_bucket = "sql-windows-function-huge-head-li"
database = "sql_windows_function_database"
table = "ntile_example"


client = AthenaClient(f"s3://{s3_bucket}/athena/")

n = 6
sql = f"""
    select school, department, student,
        NTILE({n}) OVER (PARTITION BY school, department ORDER BY random()) AS tile_id
    from {database}.{table}
    order by school, department, tile_id
"""

df = client.read_sql_query(sql=sql)

print(df)
