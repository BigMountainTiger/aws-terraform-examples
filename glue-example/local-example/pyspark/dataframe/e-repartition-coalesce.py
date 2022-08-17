from pyspark.sql import SparkSession
from pyspark.sql import Row

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("ERROR")


def run():
    print()
    student = spark.createDataFrame([
        Row(name='Song', subject='English', term='Spring', score=80),
        Row(name='Song', subject='English', term='Fall', score=90),
        Row(name='Song', subject='Math', term='Spring', score=90),
        Row(name='Song', subject='Math', term='Fall', score=100),
        Row(name='Donald trump', subject='English', term='Spring', score=20),
        Row(name='Donald trump', subject='English', term='Fall', score=40),
        Row(name='Donald trump', subject='Math', term='Spring', score=30),
        Row(name='Donald trump', subject='Math', term='Fall', score=25),
    ])

    student.printSchema()
    print(f'No. of partitons - {student.rdd.getNumPartitions()}')
    student.show()

    print('repartition - 3')
    df = student.repartition(3)
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')
    df.show()

    print('repartition - 4')
    df = df.repartition(4)
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')
    df.show()

    print('coalesce - 1')
    df = df.coalesce(1)
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')
    df.show()

    print('coalesce - 2')
    df = df.coalesce(2)
    print(f'No. of partitons - {df.rdd.getNumPartitions()}')
    print('Increase the No. of partitions happened with coalesce')
    df.show()


if __name__ == '__main__':
    run()
