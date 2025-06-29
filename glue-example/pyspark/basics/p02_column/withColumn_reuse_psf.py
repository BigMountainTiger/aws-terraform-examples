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
        {'student_name': 'Song Li', 'class_name': 'Science', 'score': 20},
    ])])
    df_1 = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df_1.show()

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_name': 'Trump', 'class_name': 'Math', 'score': 99},
        {'student_name': 'Trump', 'class_name': 'English', 'score': 30},
        {'student_name': 'Trump', 'class_name': 'Science', 'score': 20},
    ])])
    df_2 = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df_2.show()

    # Used in two places
    expr = psf.when(psf.col('score') >= 80, 'GOOD').otherwise('BAD')

    df = df_1.withColumn('evaluation', expr)
    df.show()

    df = df_2.withColumn('evaluation', expr)
    df.show()