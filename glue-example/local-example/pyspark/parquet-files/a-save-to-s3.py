# Download the test parquet file
# https://learn.microsoft.com/en-us/azure/open-datasets/dataset-bing-covid-19?tabs=azure-storage

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('a-read-parquet').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')


def run():
    print()

    FILE_PATH = 'workspace/data/bing_covid-19_data.parquet'

    print(f'Loading from local {FILE_PATH}')
    df = spark.read.parquet(FILE_PATH)
    print(f'Shape {(df.count(), len(df.columns))}')
    print(f'No. of partitions {df.rdd.getNumPartitions()}')

    # Bucket name can not have "." in it (although AWS s3 allows such bucket name)
    BUCKET = 'huge-head-li-2023-glue-example'
    FOLDER = 'covid-19'
    S3_PATH = f's3://{BUCKET}/{FOLDER}'

    print()
    print(f'Saving to {S3_PATH}')
    df = df.coalesce(1)
    df.write.save(path=S3_PATH, format='parquet', mode='overwrite')
    print('Done saving to s3')

    print()
    print(f'Loading back from {S3_PATH}')
    df = spark.read.parquet(S3_PATH)
    print(f'Shape {(df.count(), len(df.columns))}')
    print(f'No. of partitions {df.rdd.getNumPartitions()}')

if __name__ == "__main__":
    run()
