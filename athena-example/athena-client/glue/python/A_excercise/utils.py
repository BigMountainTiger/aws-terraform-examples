from datetime import datetime
import boto3
import awswrangler as wr
import pandas as pd


def get_mnt():
    now = datetime.now()
    return now.strftime("%Y-%m")


class AthenaClient:
    def __init__(self, database, s3_athena_output_location):
        self.database = database
        self.s3_athena_output_location = s3_athena_output_location

    def run(self, sql):
        client = boto3.client("athena")
        response = client.start_query_execution(
            QueryExecutionContext={"Database": self.database},
            QueryString=sql,
            ResultConfiguration={
                'OutputLocation': self.s3_athena_output_location
            }
        )

        QueryExecutionId = response['QueryExecutionId']
        result = wr.athena.wait_query(QueryExecutionId)
        state = result['Status']['State']

        if state != 'SUCCEEDED':
            raise Exception(f'The execution {QueryExecutionId} state is {state}, SUCCEEDED is expected')

        return state


class JobManager:
    def __init__(self, database, mnt, s3_database_location, athena_client):
        self.database = database
        self.table = 'job_status'
        self.mnt = mnt

        self.athena_client = athena_client
        self.s3_table_location = f'{s3_database_location}/{self.table}'
        self.s3_table_mnt_data_fiie_path = f'{self.s3_table_location}/prefix_{self.mnt}.parquet'

        sql = f"""
            CREATE external TABLE IF NOT EXISTS {self.database}.{self.table} (
                mnt string, step string, status string
            )
            STORED AS PARQUET
            LOCATION '{self.s3_table_location}'
        """

        self.athena_client.run(sql)

    def _update_step(self, step, status):
        df = pd.DataFrame({
            'mnt': [self.mnt],
            'step': [step],
            'status': [status]
        })
        
        df.to_parquet(self.s3_table_mnt_data_fiie_path, engine='pyarrow', index=False)

    def start(self, step):
        self._update_step(step, 'starting')


    def complete(self, step):
        self._update_step(step, 'completed')
