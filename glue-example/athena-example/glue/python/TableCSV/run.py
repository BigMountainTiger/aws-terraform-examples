import pandas as pd
import awswrangler as wr
from athena_client import AthenaClient
from csv_client import CSVClient

database_name = 'athena_example_database'
bucket = 'athena-example-huge-head-li'
s3_database_dir = f's3://{bucket}/database/{database_name}'
s3_athena_output_dir = f's3://{bucket}/temp/athena'

csv_client = CSVClient()
athena_client = AthenaClient(database_name, s3_athena_output_dir)

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


class TableCSVSimple:
    def __init__(self):
        self.database_name = database_name
        self.table_name = 'table_csv_simple'
        self.s3_table_path = f'{s3_database_dir}/{self.table_name}'

    def create_table(self):
        sql = f"""
            CREATE EXTERNAL TABLE IF NOT EXISTS {self.database_name}.{self.table_name} (
                id INT, name STRING, age INT
            )
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
            WITH SERDEPROPERTIES (
                'separatorChar' = ',',
                'quoteChar' = '"'
            )
            STORED AS TEXTFILE
            LOCATION '{self.s3_table_path}'
            TBLPROPERTIES (
                'skip.header.line.count'='1'
            )
        """

        athena_client.execute_sql_query(sql)

    def insert_data(self):
        df1 = pd.DataFrame(DATA_SET_1)
        csv_client.write_csv(df1, f'{self.s3_table_path}/data1.csv')

        df2 = pd.DataFrame(DATA_SET_2)
        csv_client.write_csv(df2, f'{self.s3_table_path}/data2.csv')

        athena_client.repair_glue_table(self.table_name)

    def clear_data(self):
        wr.s3.delete_objects(path=self.s3_table_path)
        athena_client.execute_sql_query(sql=f"DROP TABLE IF EXISTS {self.database_name}.{self.table_name};")

    def run(self):
        self.clear_data()
        self.create_table()
        self.insert_data()

        print('Tested TableCSVSimple')


class TableCSVPartitioned:
    def __init__(self):
        self.database_name = database_name
        self.table_name = 'table_csv_partitioned'
        self.s3_table_path = f'{s3_database_dir}/{self.table_name}'

    def create_table(self):
        sql = f"""
            CREATE EXTERNAL TABLE IF NOT EXISTS {self.database_name}.{self.table_name} (
                id INT, name STRING, age INT
            )
            PARTITIONED BY (team INT)
            ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
            WITH SERDEPROPERTIES (
                'separatorChar' = ',',
                'quoteChar' = '"'
            )
            STORED AS TEXTFILE
            LOCATION '{self.s3_table_path}'
            TBLPROPERTIES (
                'skip.header.line.count'='1'
            )
        """

        athena_client.execute_sql_query(sql)

    def insert_data(self):
        df1 = pd.DataFrame(DATA_SET_1)
        csv_client.write_csv(df1, f'{self.s3_table_path}/team=1/data1.csv')

        df2 = pd.DataFrame(DATA_SET_2)
        csv_client.write_csv(df2, f'{self.s3_table_path}/team=2/data2.csv')

        athena_client.repair_glue_table(self.table_name)

    def clear_data(self):
        wr.s3.delete_objects(path=self.s3_table_path)
        athena_client.execute_sql_query(sql=f"DROP TABLE IF EXISTS {self.database_name}.{self.table_name};")

    def run(self):
        self.clear_data()
        self.create_table()
        self.insert_data()

        print('Tested TableCSVPartitioned')


if __name__ == '__main__':
    table_csv_simple = TableCSVSimple()
    table_csv_simple.run()

    table_csv_partitioned = TableCSVPartitioned()
    table_csv_partitioned.run()