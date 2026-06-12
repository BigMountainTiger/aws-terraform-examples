import awswrangler as wr
import pandas as pd


s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/temp/athena'
s3_database_dir = f's3://{s3_bucket}/database'

if __name__ == "__main__":

    database_name = "awswrangler_iceberg_example_db"
    table_name = "student"

    def insert_data():
        data = {
            "id": [4, 5, 6],
            "name": ["David", "Eve", "Frank"],
            "score": [None, None, 99]
        }

        df = pd.DataFrame(data)
        df = df.convert_dtypes()

        df.info()

        wr.athena.to_iceberg(
            df=df,
            database=database_name,
            table=table_name,
            table_location=f"{s3_database_dir}/{database_name}/{table_name}",
            s3_output=s3_athena_output_dir,
            temp_path=s3_athena_output_dir,
            keep_files=False,
            schema_evolution=True,
            fill_missing_columns_in_df=True
        )

        print(f"Data inserted into table '{table_name}' in database '{database_name}'")

    insert_data()
