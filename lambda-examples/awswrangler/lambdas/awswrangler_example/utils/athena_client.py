import boto3
import awswrangler as wr


class AthenaClient:
    def __init__(self, s3_athena_output_dir, default_database=None):

        self.default_database = 'default' if default_database is None else default_database
        self.s3_athena_output_dir = s3_athena_output_dir

    def clear_s3_athena_output_dir(self):
        wr.s3.delete_objects(path=self.s3_athena_output_dir)

    def repair_glue_table(self, table_name):
        self.execute_sql_query(f"MSCK REPAIR TABLE {table_name};")

    def execute_sql_query(self, sql):
        client = boto3.client("athena")
        response = client.start_query_execution(
            QueryExecutionContext={"Database": self.default_database},
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

    def read_sql_query(self, sql, ctas_approach=False, unload_approach=False, chunksize=None):
        # https://aws-sdk-pandas.readthedocs.io/en/stable/stubs/awswrangler.athena.read_sql_query.html
        # ctas_approach & unload_approach

        df = wr.athena.read_sql_query(
            sql=sql,
            database=self.default_database,
            ctas_approach=ctas_approach,
            unload_approach=unload_approach,
            s3_output=self.s3_athena_output_dir,
            chunksize=chunksize
        )

        return df
    

