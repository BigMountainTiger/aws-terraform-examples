import pyspark_utils
from pyspark.sql import functions as F

database_name = "pyspark_iceberg_example_db"
table_name = "student"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    columns = ["id", "name", "status"]

    data = []
    for i in range(1, 6):
        data.append((i, f"Student {i}", "NEW"))

    df = spark.createDataFrame(data, columns)
    df = df.withColumn("is_deleted", F.lit(False))
    df.createOrReplaceTempView("incoming_data")

    full_table_name = f'glue_catalog.{database_name}.{table_name}'
    sql = f"""
        MERGE INTO {full_table_name} AS t
        USING incoming_data AS s
        ON t.id = s.id
        WHEN MATCHED AND s.is_deleted = True THEN
            DELETE
        WHEN MATCHED AND s.is_deleted = False THEN
            UPDATE SET {', '.join([f't.{c} = s.{c}' for c in columns])}
        WHEN NOT MATCHED AND s.is_deleted = False THEN
            INSERT ({', '.join(columns)}) VALUES ({', '.join([f's.{c}' for c in columns])})
    """

    spark.sql(sql)
    print('Data inserted/updated/deleted successfully.')
