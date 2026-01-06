import boto3
import awswrangler as wr


class AthenaClient:
    def __init__(self, database, s3_athena_output_dir):
        self.database = database
        self.s3_athena_output_dir = s3_athena_output_dir

    def clear_s3_athena_output_dir(self):
        wr.s3.delete_objects(path=self.s3_athena_output_dir)

    def repair_glue_table(self, table_name):
        self.execute_sql_query(f"MSCK REPAIR TABLE {table_name};")

    def execute_sql_query(self, sql):
        client = boto3.client("athena")
        response = client.start_query_execution(
            QueryExecutionContext={"Database": self.database},
            QueryString=sql,
            ResultConfiguration={
                'OutputLocation': self.s3_athena_output_dir
            }
        )

        QueryExecutionId = response['QueryExecutionId']
        result = wr.athena.wait_query(QueryExecutionId)
        state = result['Status']['State']

        if state != 'SUCCEEDED':
            raise Exception(f'The execution {QueryExecutionId} state is {state}, SUCCEEDED is expected')

        return state

    def read_sql_query(self, sql, ctas_approach=False, unload_approach=False):
        # https://aws-sdk-pandas.readthedocs.io/en/stable/stubs/awswrangler.athena.read_sql_query.html
        # ctas_approach & unload_approach

        df = wr.athena.read_sql_query(
            sql=sql,
            database=self.database,
            ctas_approach=ctas_approach,
            unload_approach=unload_approach,
            s3_output=self.s3_athena_output_dir
        )

        return df
