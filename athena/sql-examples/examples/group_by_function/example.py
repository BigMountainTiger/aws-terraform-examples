import pyarrow as pa
import pandas as pd
from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
table = "frac_example"


client = AthenaClient(f"s3://{s3_bucket}/athena/")

sql = f"""
    WITH texts AS (
        select 'ABC' as T
        union all
        select '  aBc   ' as T
        union all
        select 'Abc     ' as T
        union all
        select '     def ' as T
        union all
        select 'DEF' as T
        union all
        select 'DEF ' as T
        union all
        select '    Def ' as T
    )
    select UPPER(TRIM(T)) as T, count(*) as ct from texts
    group by UPPER(TRIM(T))
    order by T
"""

df = client.read_sql_query(sql=sql)
df = df.convert_dtypes(dtype_backend="pyarrow")

df.info()
print(df)
