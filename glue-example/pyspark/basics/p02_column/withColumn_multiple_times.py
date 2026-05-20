import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student_name", T.StringType()),
        T.StructField("class_name", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_name': 'Song Li', 'class_name': 'Math', 'score': 99},
        {'student_name': 'Song Li', 'class_name': 'English', 'score': 98},
        {'student_name': 'Song Li', 'class_name': 'Science', 'score': 97},
        {'student_name': 'Trump', 'class_name': 'Math', 'score': 33},
        {'student_name': 'Trump', 'class_name': 'English', 'score': 33}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.printSchema()
    df.show()

    # withColumn is accumulative, the final score is "score + 2"
    df = df.withColumn('score', psf.col('score') + 1)
    df = df.withColumn('score', psf.col('score') + 1)

    df.printSchema()
    df.show()
