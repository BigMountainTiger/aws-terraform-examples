from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')


def run():
    print()
    print('Loading the public json data')
    df = spark.read \
        .json('s3://awsglue-datasets/examples/us-legislators/all/persons.json')

    df = df.select('family_name', 'given_name', 'birth_date')
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)

    print('Sort by birth_date - No. of partitions drops to 1')
    df = df.sort(['birth_date'])
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)

    print('Repartition to 5 - partitions are shuffled, so no long sorted')
    df = df.repartition(5)
    print(f'Total - {df.count()} in {df.rdd.getNumPartitions()} partitions')
    df.show(5)


if __name__ == '__main__':
    run()
