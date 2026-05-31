import pyspark_utils

database_name = "pyspark_iceberg_example_db"
table_name = "student"
s3_bucket = "iceberg-example-huge-head-li"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    sql = f"""
        CREATE TABLE IF NOT EXISTS glue_catalog.{database_name}.{table_name} (
            id INT,
            name STRING,
            score INT
        ) USING iceberg
        LOCATION 's3://{s3_bucket}/{database_name}/{table_name}/'
    """
    spark.sql(sql)
    print(f"Table '{table_name}' created in database '{database_name}'.")


