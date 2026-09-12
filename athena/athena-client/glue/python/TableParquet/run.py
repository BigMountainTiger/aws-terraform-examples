import pandas as pd
import awswrangler as wr
from athena_client import AthenaClient
from parquet_client import ParquetClient

database_name = 'athena_example_database'
bucket = 'athena-example-huge-head-li'
s3_database_dir = f's3://{bucket}/database/{database_name}'
s3_athena_output_dir = f's3://{bucket}/temp/athena'

parquet_client = ParquetClient()
athena_client = AthenaClient(s3_athena_output_dir, default_database=database_name)

DATA_SET_1 = [
    {'id': 1, 'name': 'Alice', 'age': 30},
    {'id': 2, 'name': 'Bob', 'age': 25},
    {'id': 3, 'name': 'Charlie', 'age': 35}
]

DATA_SET_2 = [
    {'id': 4, 'name': 'Song', 'age': 50},
    {'id': 5, 'name': 'Trump', 'age': 55},
    {'id': 6, 'name': 'Biden', 'age': 65}
]


class TableParquetSimple:
    def __init__(self):
        self.database_name = database_name
        self.table_name = 'table_parquet_simple'
        self.s3_table_path = f'{s3_database_dir}/{self.table_name}'

    def create_table(self):
        sql = f"""
            CREATE EXTERNAL TABLE IF NOT EXISTS {self.database_name}.{self.table_name} (
                id INT, name STRING, age INT
            )
            STORED AS PARQUET
            LOCATION '{self.s3_table_path}'
        """

        athena_client.execute_sql_query(sql)

    def insert_data(self):
        df1 = pd.DataFrame(DATA_SET_1)
        parquet_client.write_parquet(df1, f'{self.s3_table_path}/data1.parquet')

        df2 = pd.DataFrame(DATA_SET_2)
        parquet_client.write_parquet(df2, f'{self.s3_table_path}/data2.parquet')

        athena_client.repair_glue_table(self.table_name)

    def clear_data(self):
        wr.s3.delete_objects(path=self.s3_table_path)
        athena_client.execute_sql_query(sql=f"DROP TABLE IF EXISTS {self.database_name}.{self.table_name};")

    def read_data(self):
        sql = f"SELECT * FROM {self.database_name}.{self.table_name};"
        df = athena_client.read_sql_query(sql)
        print(df)

    def run(self):
        self.clear_data()
        self.create_table()
        self.insert_data()
        self.read_data()

        print('Tested TableParquetSimple.')


class TableParquetPartitioned:
    def __init__(self):
        self.database_name = database_name
        self.table_name = 'table_parquet_partitioned'
        self.s3_table_path = f'{s3_database_dir}/{self.table_name}'

    def create_table(self):
        sql = f"""
            CREATE EXTERNAL TABLE IF NOT EXISTS {self.database_name}.{self.table_name} (
                id INT, name STRING, age INT
            )
            PARTITIONED BY (team INT)
            STORED AS PARQUET
            LOCATION '{self.s3_table_path}'
        """

        athena_client.execute_sql_query(sql)

    def insert_data(self):
        df1 = pd.DataFrame(DATA_SET_1)
        parquet_client.write_parquet(df1, f'{self.s3_table_path}/team=1/data1.parquet')

        df2 = pd.DataFrame(DATA_SET_2)
        parquet_client.write_parquet(df2, f'{self.s3_table_path}/team=2/data2.parquet')

        athena_client.repair_glue_table(self.table_name)

    def clear_data(self):
        wr.s3.delete_objects(path=self.s3_table_path)
        athena_client.execute_sql_query(sql=f"DROP TABLE IF EXISTS {self.database_name}.{self.table_name};")

    def read_data(self):
        sql = f"SELECT * FROM {self.database_name}.{self.table_name};"
        df = athena_client.read_sql_query(sql)
        print(df)

    def run(self):
        self.clear_data()
        self.create_table()
        self.insert_data()
        self.read_data()

        print('Tested TableParquetPartitioned.')


if __name__ == '__main__':
    table_parquet_simple = TableParquetSimple()
    table_parquet_simple.run()

    table_parquet_partitioned = TableParquetPartitioned()
    table_parquet_partitioned.run()
