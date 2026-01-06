import pandas as pd
from csv_client import CSVClient

database = 'athena_example_database'
bucket = 'athena-example-huge-head-li'
s3_database_dir = f's3://{bucket}/database/{database}'
csv_dir = f'{s3_database_dir}/csv'
csv_path = f'{csv_dir}/example.csv'

if __name__ == "__main__":

    csv_client = CSVClient()

    # 1. Write example CSV
    df = pd.DataFrame({
        'id': [1, 2, 3],
        'name': ['Alice', 'Bob', 'Charlie']
    })
    csv_client.write_csv(df, csv_path)

    # 2. Read example CSV
    df = csv_client.read_csv(csv_path)
    df.info()
    print(df)
