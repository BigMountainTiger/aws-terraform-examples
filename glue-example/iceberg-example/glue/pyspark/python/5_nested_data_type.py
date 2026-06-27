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

    def drop_table():
        spark.sql(f"DROP TABLE IF EXISTS {full_table_name}")
        print(f"Table '{table_name}' dropped.")

    drop_table()

    def insert_data():
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

        data = [
            {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
            {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
            {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
        ]

        df = spark.createDataFrame(data)
        df.writeTo(full_table_name).using("iceberg").tableProperty("location", s3_path)

    glue_table = get_glue_table()
    print(glue_table)
