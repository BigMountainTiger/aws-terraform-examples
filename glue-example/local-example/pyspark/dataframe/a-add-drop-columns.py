from pyspark.sql import SparkSession
from pyspark.sql.functions import lit


spark = SparkSession.builder.appName('drop-na-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("ERROR")


def run():
    print()
    data = spark.read \
        .option('header', True) \
        .option('quote', '"') \
        .option('inferSchema', True) \
        .csv("data/data-000.csv")

    data.printSchema()
    data.show()

    print('Add column with null values')
    df = data.withColumn('Score', lit(None))
    df.show()

    print('Add column with computed values')
    df = data.withColumn('Score', data['Id'] + 90)
    df.show()

    print('Rename a column')
    df = df.withColumnRenamed('score', 'new-score')
    df.show()

    print('Drop columns - No error if the column name non-exist')
    df = df.drop('new-score', 'non-exist column')
    df.show()

    print('collect() should be used only on small dataset')
    print('https://sparkbyexamples.com/pyspark/pyspark-collect/')
    result = df.collect()
    print(result)


if __name__ == '__main__':
    run()
