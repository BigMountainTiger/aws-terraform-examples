from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')

# Bucket name can not have "." in it (although AWS s3 allows such bucket name)
BUCKET = 'huge-head-li-2023-glue-example'
FOLDER = 'parquet-example'


def run():
    print()
    print('Loading the public json data')
    df = spark.read \
        .json('s3://awsglue-datasets/examples/us-legislators/all/persons.json')

    df = df.select('family_name', 'given_name', 'birth_date')
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)

    print('writting to s3 - repartition to 4 partitions')
    df = df.repartition(4)
    
    # Adding partitionBy='birth_date' is very time consuming
    df.write.save(path=f's3://{BUCKET}/{FOLDER}',
                  format='parquet', mode='overwrite')
    print('Done\n')

    print('Read the parguet data back to a DataFrame')
    df = spark.read.parquet(f's3://{BUCKET}/{FOLDER}')
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)


if __name__ == '__main__':
    run()
