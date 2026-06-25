import logging
from athena_client import AthenaClient
import pyarrow as pa
from schema.pyarrow_util import PyArrowPandasDataframeGenerator

# logging.basicConfig(level=logging.INFO)

s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    athena_client = AthenaClient(s3_athena_output_dir)

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student_nested"

    # It is possible to read large datasets in chunks to avoid memory issues
    df_generator = athena_client.read_sql_query(f"SELECT * FROM {database_name}.{table_name}", ctas_approach=True, chunksize=10000)

    schema_template = {
        "id": 0,
        "student": {
            "name": "",
            "address": "",
            "hobbies": [""],
            "age": 0,
            "tags": {"": ""},
            "physics": {
                "height": 0.0,
                "nick_name": ""
            },
            "score": 0,
        }
    }

    dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)
    dataframe_generator.print_schema()

    for df in df_generator:
        tb = pa.Table.from_pandas(df, schema=dataframe_generator.schema)
        print(tb.schema)
