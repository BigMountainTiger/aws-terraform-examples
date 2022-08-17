from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')

# Bucket name can not have "." in it (although AWS s3 allows such bucket name)
BUCKET = 'huge-head-li-2023-glue-example'
FOLDER = 'csv-example'


def run():
    print()
    print('Loading the public json data')
    df = spark.read \
        .json('s3://awsglue-datasets/examples/us-legislators/all/persons.json')

    df = df.select('family_name', 'given_name', 'birth_date')
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)

    print('writting to s3')
    df = df.repartition(4)
    df.write.option('header', True) \
        .option('quote', '"') \
        .save(path=f's3://{BUCKET}/{FOLDER}', format='csv', mode='overwrite')
    print('Done\n')

    print('Reading the data back into a DataFrame')
    df = spark.read.option('header', True) \
        .option('quote', '"') \
        .csv(path=f's3://{BUCKET}/{FOLDER}')

    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)


if __name__ == "__main__":
    run()
