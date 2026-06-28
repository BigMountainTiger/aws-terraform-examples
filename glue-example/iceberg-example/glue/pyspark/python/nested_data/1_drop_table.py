import pyspark_utils

s3_bucket = "iceberg-example-huge-head-li"

database_name = "pyspark_iceberg_example_db"
table_name = "student"

full_table_name = f'glue_catalog.{database_name}.{table_name}'
s3_path = f's3://{s3_bucket}/{database_name}/{table_name}/'


if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    def drop_table():
        spark.sql(f"DROP TABLE IF EXISTS {full_table_name}")
        print(f"Table '{table_name}' dropped.")

    drop_table()
