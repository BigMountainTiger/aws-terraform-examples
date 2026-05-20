# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-connect-jdbc-home.html
import logging
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue import DynamicFrame
from awsglue.job import Job

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


sc = SparkContext.getOrCreate()
sc.setLogLevel('WARN')

glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

host = 'host.docker.internal'
database = 'postgres'

base_option = {
    'url': f'jdbc:postgresql://{host}:5432/{database}',
    'schema': 'public',
    'user': 'postgres',
    'password': 'docker'
}


def database_read():
    option = base_option.copy()
    option['dbtable'] = 'student_source'
    option['sampleQuery'] = 'SELECT * FROM public.student_source limit 3'

    df = glueContext.create_dynamic_frame_from_options(connection_type='postgresql', connection_options=option).toDF()
    return df


def database_write(df):
    option = base_option.copy()
    option['dbtable'] = 'student_target'
    # preactions is ignored, but succeeded with "from_jdbc_conf" which requires an AWS glue connection
    option['preactions'] = 'truncate table public.student_target;'

    df = DynamicFrame.fromDF(df, glueContext, 'transform')
    # glueContext.write_dynamic_frame.from_options(frame=df, connection_type='postgresql', connection_options=option)

    # This wont work without a catalog_connection. A fake-connection is not allowed by aws
    glueContext.write_dynamic_frame.from_jdbc_conf(frame=df, catalog_connection='fake-connection', connection_options=option)


if __name__ == '__main__':
    df = database_read()
    df.printSchema()
    df.show()

    logger.info('Writting to the database')
    database_write(df)

    logger.info('Done')
