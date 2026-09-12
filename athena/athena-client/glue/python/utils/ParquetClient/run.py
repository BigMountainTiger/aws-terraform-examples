import pandas as pd
from parquet_client import ParquetClient

database = 'athena_example_database'
bucket = 'athena-example-huge-head-li'
s3_database_dir = f's3://{bucket}/database/{database}'
parquet_dir = f'{s3_database_dir}/parquet'
parquet_path = f'{parquet_dir}/example.parquet'

if __name__ == "__main__":

    parquet_client = ParquetClient()

    # 1. Write example Parquet
    df = pd.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })
    parquet_client.write_parquet(df, parquet_path)

    # 2. Read example Parquet
    df = parquet_client.read_parquet(parquet_path)
    df.info()
    print(df)
