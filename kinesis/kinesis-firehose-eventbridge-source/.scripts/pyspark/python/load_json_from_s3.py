import multiprocessing as mp
from pyspark.sql import SparkSession
from awsglue.context import GlueContext

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')
glueContext = GlueContext(sc)

# Need to make sure the s3path has data files before running the example
s3path = 's3://kinesis-firehose-example-huge-head-li/data/year=2024/month=10/day=04/hour=15/'
s3path = 's3://kinesis-firehose-example-huge-head-li/data/year=2024/month=10/day=04/'

s3path = "s3://kinesis-firehose-example-huge-head-li/data"

# https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-format-json-home.html


def run_by_glueContext():
    print()
    print('Loading the json data')

    ddf = glueContext.create_dynamic_frame.from_options(
        connection_type='s3',
        connection_options={
            'paths': [s3path],
            'recurse': True
        },
        format_options={
            "multiline": True,
        },
        format='json')

    df = ddf.toDF()

    df.show()
    print(f'count - {df.count()}')
    print(f'No. of CPU cores - {mp.cpu_count()}')
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')


def run_by_spark():
    print()
    print('Loading the json data')
    df = spark.read \
        .json(s3path)

    df.show()
    print(f'count - {df.count()}')
    print(f'No. of CPU cores - {mp.cpu_count()}')
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')


# The spark.read and create_dynamic_frame use different number of partitions
if __name__ == "__main__":
    # run_by_spark()
    run_by_glueContext()
