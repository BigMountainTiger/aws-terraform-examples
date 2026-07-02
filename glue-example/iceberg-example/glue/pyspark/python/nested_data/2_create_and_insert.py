from utils import pyspark_utils
from utils import pyspark_iceberg_utils as piu
from pyspark.sql import functions as F

s3_bucket = "iceberg-example-huge-head-li"

database_name = "pyspark_iceberg_example_db"
table_name = "student"

full_table_name = f'glue_catalog.{database_name}.{table_name}'
s3_path = f's3://{s3_bucket}/{database_name}/{table_name}/'


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

    df = create_data_frame()

    # Add the batch column for de-duplication purpose
    df = df.withColumn("batch_hour", F.lit(1).cast("int"))
    df.printSchema()
    df.show()

    glue_table = piu.get_glue_table(database_name, table_name)

    if glue_table is None:
        df.writeTo(full_table_name) \
            .using("iceberg") \
            .tableProperty("location", s3_path) \
            .tableProperty("write.spark.accept-any-schema", "true") \
            .partitionedBy("batch_hour") \
            .create()

        print(f"Table '{table_name}' created.")
    else:
        print(f"Table '{table_name}' already exists.")
