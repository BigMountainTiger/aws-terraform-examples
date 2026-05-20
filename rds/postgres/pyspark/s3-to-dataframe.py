import time
import parameters
from pyspark.sql import SparkSession

spark: SparkSession = SparkSession.builder.appName(
    's3-to-dataframe').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')

S3_PATH = parameters.S3_PATH

start_time = time.time()
print()
print('Read the parguet data to a DataFrame')
df = spark.read.parquet(S3_PATH)
print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
df.show(5)

execution_time = time.time() - start_time
print(f'Done loading from s3 {execution_time} seconds')
