import pyspark_utils

database_name = "pyspark_iceberg_example_db"
table_name = "student"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    columns = ["id", "name", "score"]
    data = [(1, "Alice", 85), (2, "Bob", 90), (3, "Charlie", 78)]
    df = spark.createDataFrame(data, columns)

    df.write \
        .format("iceberg") \
        .mode("append") \
        .save(f"glue_catalog.{database_name}.{table_name}")


