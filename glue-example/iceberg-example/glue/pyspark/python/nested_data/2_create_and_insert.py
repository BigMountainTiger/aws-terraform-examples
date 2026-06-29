from botocore.exceptions import ClientError
import boto3
import pyspark_utils
from pyspark.sql import functions as F

s3_bucket = "iceberg-example-huge-head-li"

database_name = "pyspark_iceberg_example_db"
table_name = "student"

full_table_name = f'glue_catalog.{database_name}.{table_name}'
s3_path = f's3://{s3_bucket}/{database_name}/{table_name}/'


def get_glue_table():
    try:
        glue_client = boto3.client('glue')
        response = glue_client.get_table(DatabaseName=database_name, Name=table_name)

        return response['Table']
    except ClientError as e:
        if e.response['Error']['Code'] == 'EntityNotFoundException':
            return None
        else:
            raise


if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    def create_date_schema():
        schema_template = {
            "id": 0,
            "student": {
                "name": "",
                "score": 0,
                "hobbies": [""],
                "age": 0,
                "tags": {"": ""}
            }
        }

        return pyspark_utils.generate_schema_from_json_data(schema_template)

    pyspark_schema = create_date_schema()

    def create_data_frame():
        data = [
            {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
            {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
            {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
        ]

        df = spark.createDataFrame(data, schema=pyspark_schema)
        return df

    glue_table = get_glue_table()
    df = create_data_frame()
    df.show()

    if glue_table is None:
        df.writeTo(full_table_name).using("iceberg").tableProperty("location", s3_path).create()
        print(f"Table '{table_name}' created.")
    else:
        print(f"Table '{table_name}' already exists.")
