import io
import json
from athena_client import AthenaClient
import awswrangler as wr
import pandas as pd
import pyarrow as pa
import pyarrow.json as pj


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    athena_client = AthenaClient(s3_athena_output_dir)

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student_nested"

    def drop_table():
        athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {database_name}.{table_name}")
        print("Table dropped")

    def insert_data(df):
        wr.athena.to_iceberg(
            df=df,
            database=database_name,
            table=table_name,
            table_location=f"{s3_database_dir}/{database_name}/{table_name}",
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False,
            schema_evolution=False,
            fill_missing_columns_in_df=True
        )

        print(f"Data inserted into table '{table_name}' in database '{database_name}'")

    def get_pandas_dataframe(data):
        student_type = pa.struct([
            pa.field("name", pa.string()),
            pa.field("score", pa.int64()),
            pa.field("hobbies", pa.list_(pa.string())),
            pa.field("age", pa.int64())
        ])

        schema = pa.schema([
            pa.field("id", pa.int64()),
            pa.field("student", student_type)
        ])

        table = pa.Table.from_pylist(data, schema=schema)
        df = table.to_pandas(types_mapper=pd.ArrowDtype)

        return df

    drop_table()

    # First batch
    data = [
        {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
        {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
        {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
    ]
    df = get_pandas_dataframe(data)
    insert_data(df)

    # Second batch
    # The extra_field will be ignored by pyarrow, it is not in the schema
    data = [
        {"id": 4, "student": {"name": "David", "score": 100, "age": 20, "extra_field": "value"}},
        {"id": 5, "student": {"name": "Eve", "hobbies": []}},
        {"id": 6, "student": {"name": "Frank", "hobbies": ["hiking", "photography"]}},
        {"id": 7, "student": None},
        {"id": 8, "student": {}},
        {"id": 9}
    ]
    df = get_pandas_dataframe(data)
    insert_data(df)
