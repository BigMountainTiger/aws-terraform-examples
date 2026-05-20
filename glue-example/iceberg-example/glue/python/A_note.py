import logging
import boto3
import awswrangler as wr
import pandas as pd

logging.basicConfig(level=logging.INFO)
log = logging.getLogger()

log.info('Configured the logger')

s3_bucket = ''
s3_athena_workspace = f's3://{s3_bucket}/athena/'
database_name = ''

# ------------------------------------------------

table_name = 'iceberg_table'

s3_table_location = f's3://{s3_bucket}/{database_name}/{table_name}/'

create_table_sql = f"""
    CREATE TABLE IF NOT EXISTS {database_name}.{table_name} (
        id INT,
        name STRING
    )
    LOCATION '{s3_table_location}'
    TBLPROPERTIES ( 'table_type' = 'ICEBERG', 'format' = 'PARQUET' )
"""

athena_client = boto3.client("athena")
response = athena_client.start_query_execution(
    QueryExecutionContext={"Database": database_name, "Catalog": table_name},
    QueryString=create_table_sql,
    ResultConfiguration={
        'OutputLocation': s3_athena_workspace
    }
)

QueryExecutionId = response['QueryExecutionId']
print(f'Waiting for {QueryExecutionId} to complete')
query_result = wr.athena.wait_query(QueryExecutionId)
state = query_result['Status']['State']

print(f'The query {state}')

# ------------------------------------------------

temp_table_name = f'{table_name}_temp'
s3_temp_location = f"s3://{s3_bucket}/temp/{temp_table_name}"

def clean_up():
    wr.s3.delete_objects(path=s3_temp_location)
    wr.catalog.delete_table_if_exists(database=database_name, table=temp_table_name)

try:
    df_new_data = pd.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })

    clean_up()

    wr.s3.to_parquet(
        df=df_new_data,
        path=s3_temp_location,
        index=False,
        dataset=True,
        database=database_name,
        table=temp_table_name
    )

    merge_sql = f"""
        MERGE INTO {database_name}.{table_name} AS target
        USING {database_name}.{temp_table_name} AS source ON target.id = source.id
        WHEN MATCHED THEN UPDATE SET name = source.name
        WHEN NOT MATCHED THEN INSERT (id, name) VALUES (source.id, source.name)
    """

    print(merge_sql)

    athena_client = boto3.client("athena")
    response = athena_client.start_query_execution(
        QueryExecutionContext={"Database": database_name},
        QueryString=merge_sql,
        ResultConfiguration={
            'OutputLocation': s3_athena_workspace
        }
    )

    QueryExecutionId = response['QueryExecutionId']
    print(f'Waiting for {QueryExecutionId} to complete')
    query_result = wr.athena.wait_query(QueryExecutionId)
    state = query_result['Status']['State']

    print(f'The query {state}')

finally:
    clean_up()

# ------------------------------------------------

example_csv = f's3://{s3_bucket}/example_ingestion/SF_2025_10.csv'
df = pd.read_csv(example_csv)
df = df.loc[:, ~df.columns.str.contains('^Unnamed')]
df = df.rename(columns={c[0]: c[0].replace(' ', '_') for c in df.dtypes.items()})

def save_to_parquet_glue_table(database_name, table_name, df):
    table_s3_location = f"s3://{s3_bucket}/{database_name}/{table_name}"

    wr.s3.delete_objects(path=table_s3_location)
    wr.catalog.delete_table_if_exists(database=database_name, table=table_name)

    df.to_parquet(f'{table_s3_location}/{table_name}.parquet', engine='pyarrow', index=False)
    
    sql_type_map = {
        'object': 'string',
        'bool': 'boolean'
    }

    sql_column_list = [f'{n} {sql_type_map[str(t)]}' for n, t in df.dtypes.items()]    
    create_table_sql = f"""
        CREATE External TABLE IF NOT EXISTS {database_name}.{table_name} ({', '.join(sql_column_list)})
        STORED AS PARQUET
        LOCATION '{table_s3_location}'
    """
    
    athena_client = boto3.client("athena")
    response = athena_client.start_query_execution(
        QueryExecutionContext={"Database": database_name, "Catalog": table_name},
        QueryString=create_table_sql,
        ResultConfiguration={
            'OutputLocation': s3_athena_workspace
        }
    )

    QueryExecutionId = response['QueryExecutionId']
    print(f'Waiting for {QueryExecutionId} to complete')
    query_result = wr.athena.wait_query(QueryExecutionId)
    state = query_result['Status']['State']
    
    print(f'The query {state}')
    
save_to_parquet_glue_table(database_name, 'example_ingestion', df)

print('Done')

# ------------------------------------------------