import io
import json
from athena_client import AthenaClient
import awswrangler as wr
import pandas as pd


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    athena_client = AthenaClient(s3_athena_output_dir)

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student_nested"

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

    # 1. Drop the table
    athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {database_name}.{table_name}")
    print("Table dropped")

    # 2. Insert first batch of data
    data = [
        {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
        {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
        {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
    ]

    df = pd.read_json(io.StringIO(json.dumps(data))).convert_dtypes()
    insert_data(df)

    print("first batch of data inserted")

    # 4. Insert second batch of data
    data = [
        {"id": 4, "student": {"name": "David", "score": 100}},
        {"id": 5, "student": {"name": "Eve", "hobbies": []}},
        {"id": 6, "student": {"name": "Frank", "hobbies": ["hiking", "photography"]}},
        {"id": 7, "student": None}
    ]

    df = pd.read_json(io.StringIO(json.dumps(data))).convert_dtypes()
    insert_data(df)

    print("second batch of data inserted")
