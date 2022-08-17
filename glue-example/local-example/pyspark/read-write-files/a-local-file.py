from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')


def run():
    print()

    df = spark.read \
        .option('header', True) \
        .option('quote', '"') \
        .csv('data/data-000.csv')

    df.show()


if __name__ == "__main__":
    run()
