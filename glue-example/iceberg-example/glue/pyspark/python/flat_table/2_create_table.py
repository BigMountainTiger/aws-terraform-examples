import pyspark_utils

database_name = "pyspark_iceberg_example_db"
table_name = "student"
s3_bucket = "iceberg-example-huge-head-li"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    full_table_name = f'glue_catalog.{database_name}.{table_name}'
    s3_path = f's3://{s3_bucket}/{database_name}/{table_name}/'

    sql_drop = f"DROP TABLE IF EXISTS {full_table_name}"
    sql_create = f"""
        CREATE TABLE IF NOT EXISTS {full_table_name} (
            id INT,
            name STRING,
            status STRING
        ) USING iceberg
        LOCATION '{s3_path}'
    """

    spark.sql(sql_drop)
    spark.sql(sql_create)

    print(f"Table '{table_name}' created in database '{database_name}'.")


