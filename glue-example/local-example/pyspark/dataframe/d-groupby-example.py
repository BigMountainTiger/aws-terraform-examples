from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql.functions import avg, min, max

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
    student.show()

    print('Get the aggregations')
    df = student.groupBy('name', 'subject').agg(
        avg('score').alias("avg_score"),
        min('score').alias("min_score"),
        max('score').alias("max_score")
    )

    df.show()


if __name__ == '__main__':
    run()
