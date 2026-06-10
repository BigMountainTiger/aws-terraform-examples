import pyspark_utils
from pyspark.sql import functions as F

database_name = "pyspark_iceberg_example_db"
table_name = "student"

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    columns = ["id", "name", "status"]

    # New
    data_new = [
        (6, "Student 6", "NEW"),
        (7, "Student 7", "NEW")
    ]

    df_new = spark.createDataFrame(data_new, columns)
    df_new = df_new.withColumn("is_deleted", F.lit(False))

    # Update
    data_update = [
        (3, "Student 3", "UPDATED"),
        (4, "Student 4", "UPDATED"),
        (5, "Student 5", "UPDATED")
    ]

    df_update = spark.createDataFrame(data_update, columns)
    df_update = df_update.withColumn("is_deleted", F.lit(False))

    # Delete
    data_delete = [
        (1, "Student 1", "DELETED"),
        (2, "Student 2", "DELETED")
    ]

    df_delete = spark.createDataFrame(data_delete, columns)
    df_delete = df_delete.withColumn("is_deleted", F.lit(True))


    df_combined = df_update.unionByName(df_new).unionByName(df_delete)
    df_combined.createOrReplaceTempView("incoming_data")

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

