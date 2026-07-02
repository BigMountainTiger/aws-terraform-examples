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
        piu.validate_existing_table_is_iceberg(glue_table)

        batch_hours = [str(row["batch_hour"]) for row in df.collect()]
        delete_sql = f"DELETE FROM {full_table_name} WHERE batch_hour IN ({','.join(batch_hours)});"
        spark.sql(delete_sql)

        df.writeTo(full_table_name).option("mergeSchema", "true").append()
        print(f"Data appended to table '{table_name}'.")
