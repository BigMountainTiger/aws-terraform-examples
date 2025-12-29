import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T
import pyspark.sql as ps

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    data = [
        {'id': None, 'student': 'X', 'score': 100},
        {'id': 1, 'student': 'Song', 'score': 100},
        {'id': 2, 'student': 'Trump', 'score': 20},
        {'id': 3, 'student': 'Biden', 'score': 20}
    ]

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("student", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    df.printSchema()


    print('Cast a string column to an integer column results in null values')
    print('Is it terrible?')
    
    df = df.withColumn('student', psf.col('student').cast(T.IntegerType()))
    df.show()

    df.printSchema()