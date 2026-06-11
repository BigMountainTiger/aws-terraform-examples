from athena_client import AthenaClient

if __name__ == "__main__":

    database_name = "pyspark_iceberg_example_db"
    sql = f"CREATE DATABASE IF NOT EXISTS {database_name}"

    # athena_client = AthenaClient()
    # athena_client.execute_sql(sql)
    # print(f"Database '{database_name}' created.")
