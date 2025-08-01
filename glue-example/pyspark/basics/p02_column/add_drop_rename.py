import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': None, 'student': 'X'},
        {'id': 1, 'student': 'Song'}
    ])])

    # Initial dataframe
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST')
    df.printSchema()
    df.show()

    # Add column
    df = df.withColumn('score', psf.lit(100))
    df.printSchema()
    df.show()

    # Change data type
    df = df.withColumn('score', psf.col('score').cast('long'))
    df.printSchema()
    df.show()

    # Rename column, it can rename multiple columns
    df = df.withColumnsRenamed({'student': 'student_name'})
    df.printSchema()
    df.show()

    # Drop columns
    df = df.drop('score')
    df.printSchema()
    df.show()
