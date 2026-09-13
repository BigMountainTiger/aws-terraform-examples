from athena_client import AthenaClient

s3_bucket = "sql-windows-function-huge-head-li"
database = "sql_windows_function_database"
table = "frac_example"


client = AthenaClient(f"s3://{s3_bucket}/athena/")

frac = 0.2
sql = f"""
WITH ranked_data AS (
    select school, department, student,
        ROW_NUMBER() OVER (PARTITION BY school, department ORDER BY random()) AS rn,
        COUNT(*) OVER (PARTITION BY school, department) AS ct
    from {database}.{table}
)
select *
from ranked_data
where rn < {frac} * ct + 1
order by school, department, rn
"""

df = client.read_sql_query(sql=sql)

print(df)
