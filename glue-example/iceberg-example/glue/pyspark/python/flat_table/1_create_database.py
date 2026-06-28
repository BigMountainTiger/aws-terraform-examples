import pyspark_utils

database_name = "pyspark_iceberg_example_db"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    spark.sql(f"CREATE DATABASE IF NOT EXISTS glue_catalog.{database_name}")
    print(f"Database '{database_name}' created.")


