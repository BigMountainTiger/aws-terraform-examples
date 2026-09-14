from athena_client import AthenaClient

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
table = "multi_column_in_condition"


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



