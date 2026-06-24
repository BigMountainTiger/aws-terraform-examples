import json
from pathlib import Path
from utils.athena_client import AthenaClient
from utils.pyarrow_util import PyArrowPandasDataframeGenerator
import awswrangler as wr


s3_bucket = "lambda-awswrangler-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'
database_name = "lambda_awswrangler_iceberg_example_db"
table_name = "student_nested"

athena_client = AthenaClient(s3_athena_output_dir)


def lambda_handler(event, context):

    def create_glue_database():
        athena_client.execute_sql_query(f"CREATE DATABASE IF NOT EXISTS {database_name}")

    # Data base created by the terraform
    # create_glue_database()

    def drop_table():
        athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {database_name}.{table_name}")
        print("Table dropped")

    # Append
    def append_to_iceberg_table(df):
        wr.athena.to_iceberg(
            df=df,
            database=database_name,
            table=table_name,
            table_location=f"{s3_database_dir}/{database_name}/{table_name}",
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False,
            schema_evolution=False,
            fill_missing_columns_in_df=True,
        )

    # To merge set the merge_cols parameter
    def merge_to_iceberg_table(df):
        wr.athena.to_iceberg(
            df=df,
            database=database_name,
            table=table_name,
            table_location=f"{s3_database_dir}/{database_name}/{table_name}",
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False,
            schema_evolution=False,
            fill_missing_columns_in_df=True,
            merge_cols=["id"]
        )

    # To delete use delete_from_iceberg_table
    def delete_from_iceberg_table(df):
        wr.athena.delete_from_iceberg_table(
            df=df,
            database=database_name,
            table=table_name,
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False,
            merge_cols=["id"]
        )

    def create_dataframe_generator():
        file_path = Path(__file__).resolve().parent
        schema_template = json.load(open(f"{file_path}/iceberg/schema.json"))
        dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)
        dataframe_generator.print_schema()

        return dataframe_generator

    drop_table()
    dataframe_generator = create_dataframe_generator()

    # First batch
    data = [
        {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
        {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
        {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
    ]
    df = dataframe_generator.generate_dataframe(data)
    append_to_iceberg_table(df)

    # Second batch
    data = [
        {"id": 1, "student": {"name": "Merged"}},
        {"id": 4, "student": {"name": "David", "score": 100, "age": 20, "extra_field": "value"}},
        {"id": 5, "student": {"name": "Eve", "hobbies": []}},
        {"id": 6, "student": {"name": "Frank", "hobbies": ["hiking", "photography"]}},
        {"id": 7, "student": None},
        {"id": 8, "student": {}},
        {"id": 9},
        {"id": 10, "student": {"tags": {"key1": "value1", "key2": "value2"}}}

    ]
    df = dataframe_generator.generate_dataframe(data)
    merge_to_iceberg_table(df)

    # Delete some records
    data = [
        {"id": 2},
        {"id": 3}
    ]
    df = dataframe_generator.generate_dataframe(data)
    delete_from_iceberg_table(df)

    return {
        'statusCode': 200,
        'body': 'Lambda function executed successfully'
    }
