import os
import json
import logging
import datetime
from pyspark.sql.functions import lit
import pyspark.sql.types as T

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()


def time_sections():
    now = datetime.datetime.now(datetime.timezone.utc)

    y = now.strftime('%Y')
    m = now.strftime('%m')
    d = now.strftime('%d')
    h = now.strftime('%H')

    return y, m, d, h


def get_spark():
    from pyspark.sql import SparkSession

    b = SparkSession.builder
    # Permissions
    b = b.config("spark.hadoop.fs.s3a.access.key", os.environ['AWS_ACCESS_KEY_ID'])
    b = b.config("spark.hadoop.fs.s3a.secret.key", os.environ['AWS_SECRET_ACCESS_KEY'])
    b = b.config("spark.hadoop.fs.session.token", os.environ['AWS_SESSION_TOKEN'])
    b = b.config("spark.hadoop.fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.TemporaryAWSCredentialsProvider")

    # s3a file system
    b = b.config("spark.jars.packages", "org.apache.hadoop:hadoop-aws:3.2.4")
    b = b.config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    b = b.config("spark.hadoop.mapreduce.fileoutputcommitter.marksuccessfuljobs", "false")

    # OPtional, if needs to specify the encryption key
    b = b.config("spark.hadoop.fs.s3a.server-side-encryption-algorithm", "SSE-KMS")
    b = b.config("fs.s3a.server-side-encryption.key", "ca768e5c-34f8-42d9-9138-da9ffee5cb94")

    spark: SparkSession = b.getOrCreate()

    spark.sparkContext.setLogLevel('ERROR')
    return spark


if __name__ == '__main__':
    spark = get_spark()

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("name", T.StringType())
    ])

    data = [{'id': 1, 'name': 'Donald Trump'}]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    y, m, d, h = time_sections()
    df = df.withColumn('year', lit(y)).withColumn('month', lit(m)).withColumn('day', lit(d)).withColumn('hour', lit(h))
    df = df.coalesce(1)

    df.printSchema()
    logger.info(df.count())

    bucket = 'bucket_name'
    bucket_path = 'bucket_path'
    s3_parquet_path = f's3a://{bucket}/{bucket_path}/a_spark_without_glue'
    df.write.save(path=s3_parquet_path, format='parquet', mode='overwrite')
    logger.info(f'Parquet file saved to {s3_parquet_path}')

    spark.stop()
