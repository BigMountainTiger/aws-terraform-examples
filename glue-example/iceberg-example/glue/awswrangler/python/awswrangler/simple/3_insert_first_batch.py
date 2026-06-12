import awswrangler as wr
import pandas as pd


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student"

    # Drop table
    def delete_table_if_exists():
        try:
            wr.catalog.delete_table_if_exists(database=database_name, table=table_name)
        except Exception as e:
            print(f"Error deleting table {table_name} in database {database_name}: {e}")


    # Insert data
    def insert_data():
        data = {
            "id": [1, 2, 3],
            "name": ["Alice", "Bob", "Charlie"],
            "score": [100, 90, 80]
        }

        df = pd.DataFrame(data)
        df = df.convert_dtypes()

        wr.athena.to_iceberg(
            df=df,
            database=database_name,
            table=table_name,
            table_location=f"{s3_database_dir}/{database_name}/{table_name}",
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False
        )

        print(f"Data inserted into table '{table_name}' in database '{database_name}'")

    delete_table_if_exists()
    insert_data()
