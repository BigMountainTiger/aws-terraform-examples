from utils import get_mnt
from utils import AthenaClient
from utils import JobManager
import awswrangler as wr

database = 'athena_example_database'
s3_bucket = 'athena-example-huge-head-li'

s3_athena_output_location = f's3://{s3_bucket}/temp/athena'
s3_database_location = f's3://{s3_bucket}/database'


if __name__ == '__main__':

    mnt = get_mnt()
    mnt = '2025-09'
    print(mnt)

    athena_client = AthenaClient(database, s3_athena_output_location)
    job_manager = JobManager(database, mnt, s3_database_location, athena_client)

    step = 'step_2'
    job_manager.start(step)
    job_manager.complete(step)

    sql = f"""
        select * from {database}.job_status where mnt = '{mnt}'
    """

    df = wr.athena.read_sql_query(database=database, sql=sql)

    print(df.head())
