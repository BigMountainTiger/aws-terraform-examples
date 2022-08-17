# Download the test parquet file
# https://learn.microsoft.com/en-us/azure/open-datasets/dataset-bing-covid-19?tabs=azure-storage

from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('a-read-parquet').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')


def run():
    print()

    FILE_PATH = 'data/bing_covid-19_data.parquet'
    df = spark.read.parquet(FILE_PATH)

    print(f'Shape {(df.count(), len(df.columns))}')
    print(f'No. of partitions {df.rdd.getNumPartitions()}')


if __name__ == "__main__":
    run()
