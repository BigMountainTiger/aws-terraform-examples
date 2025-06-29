import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("STUDENT_NAME", T.StringType()),
        T.StructField("class_name", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    # The order of the columns is decided by the schema
    rdd = spark.sparkContext.parallelize([json.dumps([
        {'STUDENT_NAME': 'Song Li', 'class_name': 'Math', 'score': 99},
        {'STUDENT_NAME': 'Song Li', 'class_name': 'English', 'score': 98},
        {'STUDENT_NAME': 'Song Li', 'class_name': 'Science', 'score': 97},
        {'STUDENT_NAME': 'Trump', 'class_name': 'Math', 'score': 33},
        {'STUDENT_NAME': 'Trump', 'class_name': 'English', 'score': 33}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.printSchema()
    df.show()

    # By default, pyspark columns are NOT case sensitive
    df = df.select(*['student_name', 'CLASS_NAME', 'Score'])
    df.printSchema()
    df.show()

    # The case sensitivity is configurable
    # spark.conf.set('spark.sql.caseSensitive', True)
    print(f"Case sensitivity = {spark.conf.get('spark.sql.caseSensitive')}")
