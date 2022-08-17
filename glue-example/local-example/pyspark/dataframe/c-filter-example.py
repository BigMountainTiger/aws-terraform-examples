from pyspark.sql import SparkSession
from pyspark.sql import Row

spark = SparkSession.builder.appName('filter-example').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel("ERROR")


def run():
    print()
    student = spark.createDataFrame([
        Row(name='Name No.1', score=1),
        Row(name='Name No.2', score=2),
        Row(name='Name No.3', score=3),
        Row(name='Name No.4', score=4),
        Row(name='Name No.5', score=5),
        Row(name='Name No.6', score=6),
        Row(name='Name No.7', score=7),
        Row(name='Name No.8', score=8),
        Row(name='Name No.9', score=9),
        Row(name='Name No.10', score=10)
    ])

    print('Student dataframe')
    student.show()
    st = student

    df = student.filter(st['score'] >= 5)
    print('Simple filter score >= 5')
    df.show()

    df = student.filter((st['score'] >= 4) & (st['score'] <= 7))
    print('Filter score >= 4 and score <= 7, & must be used')
    df.show()

    df = student.filter((st['score'] <= 3) | (st['score'] >= 8))
    print('Filter score <= 3 or score >= 8, | must be used')
    df.show()

    df = student.filter(~((st['score'] <= 3) | (st['score'] >= 8)))
    print('Filter not (score <= 3 or score >= 8), ~ must be used for negation')
    print('4 - 7 will be selected from the rows - De Morgan\'s law')
    df.show()


if __name__ == '__main__':
    run()
