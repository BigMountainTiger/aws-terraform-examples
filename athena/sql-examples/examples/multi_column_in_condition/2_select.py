import awswrangler as wr
import pandas as pd
from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
table = "multi_column_in_condition"
filter_table = "multi_column_in_condition_filter"


client = AthenaClient(f"s3://{s3_bucket}/athena/")

# 1st query
print('1st query')
sql = f"""
    select *
    from {database}.{table}
    where (id, name) in (
        (1, 'name 1'),
        (2, 'name 2')
    )
    order by mnt, id;
"""

df = client.read_sql_query(sql=sql)
print(df)


# 2nd query
print()
print('2nd query')
sql = f"""
    with items as (
        select 1 as id, 'name 1' as name 
        union
        select 2 as id, 'name 2' as name
    )
    select *
    from {database}.{table}
    where (id, name) in (
        select * from items
    )
    order by mnt, id;
"""

df = client.read_sql_query(sql=sql)
print(df)


# 3rd query
print()
print('3rd query')

def create_filter_table():
    data = {
        "id": [],
        "name": []
    }

    for i in range(1, 2 + 1):
        data["id"].append(i)
        data["name"].append(f"name {i}")

    df = pd.DataFrame(data=data)
    df = df.convert_dtypes(dtype_backend="pyarrow")

    wr.s3.to_parquet(
            df=df,
            path=f"s3://{s3_bucket}/{database}/{filter_table}",
            dataset=True,
            database=database,
            table=filter_table,
            mode="overwrite"
    )

create_filter_table()

sql = f"""
    select *
    from {database}.{table}
    where (id, name) in (
        select * from {database}.{filter_table}
    )
    order by mnt, id;
"""

df = client.read_sql_query(sql=sql)
print(df)

