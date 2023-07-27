import time
import os
import sys
from pprint import pprint
import parameters
from pyspark.sql import SparkSession

spark: SparkSession = SparkSession.builder.appName(
    'postgres-to-s3').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')

print()
print(f'pwd = {os.getcwd()}')

pprint(sys.path)
print()

URL = parameters.URL
USR = parameters.USR
PWD = parameters.PWD

rows = spark.read.format('jdbc') \
    .option('url', f'{URL}?user={USR}&password={PWD}') \
    .option('dbtable', "(select min(id) as min_id, max(id) as max_id from public.example) TOTAL") \
    .load().collect()

min_id = rows[0].asDict().get('min_id')
max_id = rows[0].asDict().get('max_id')
print(f'Loading id from {min_id} - {max_id}')

option = spark.read.format('jdbc') \
    .option('numPartitions', 5) \
    .option("partitionColumn", "id") \
    .option("lowerBound", min_id) \
    .option("upperBound", max_id) \
    .option('url', f'{URL}?user={USR}&password={PWD}') \
    .option('dbtable', 'public.example')

start_time = time.time()
df = option.load()
print(f'Total {df.count()} rows loaded')
print(f'No. of partitions {df.rdd.getNumPartitions()}')

execution_time = time.time() - start_time
print(f'Load time {execution_time} seconds')

S3_PATH = parameters.S3_PATH
print()
print(f'Saving to {S3_PATH}')

start_time = time.time()
df.write.save(path=S3_PATH, format='parquet', mode='overwrite')
execution_time = time.time() - start_time

print(f'Done saving to s3 {execution_time} seconds')