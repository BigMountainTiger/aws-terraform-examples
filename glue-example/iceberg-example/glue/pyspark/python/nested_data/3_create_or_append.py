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


def validate_existing_table_is_iceberg(glue_table):
    table_name = glue_table.get('Name')
    parameters = glue_table.get('Parameters', {})
    table_type = parameters.get('table_type') or parameters.get('TABLE_TYPE')
    classification = parameters.get('classification')

    is_iceberg = str(table_type).lower() == 'iceberg' or str(classification).lower() == 'iceberg'

    if not is_iceberg:
        raise RuntimeError(
            f"Glue table '{table_name}' already exists but is not registered as an Iceberg table."
            f"Current parameters: table_type={table_type}, classification={classification}."
        )


if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    def create_date_schema():
        # Added address and physics property
        schema_template = {
            "id": 0,
            "student": {
                "name": "",
                "address": "",
                "physics": {
                    "height": 0.0,
                    "weight": 0.0
                },
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
            {"id": 4, "student": {"name": "David", "address": "123 Main St", "score": 100, "hobbies": ["reading"]}},
            {"id": 5, "student": {"name": "Eve", "score": 90, "hobbies": ["gaming", "cooking"]}},
            {"id": 6, "student": {"name": "Frank", "physics": {"height": 170.0, "weight": 70.0}, "score": 80, "hobbies": ["hiking", "photography"]}}
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
        validate_existing_table_is_iceberg(glue_table)
        spark.sql(f"ALTER TABLE {full_table_name} SET TBLPROPERTIES ('write.spark.accept-any-schema'='true')")

        df.writeTo(full_table_name).using("iceberg").tableProperty("location", s3_path).option("mergeSchema", "true").append()
        print(f"Data appended to table '{table_name}'.")
