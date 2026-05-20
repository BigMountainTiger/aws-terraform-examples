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

    cols = {
        'score': psf.col('score').cast('long'),
        'a_score': psf.concat_ws('-', psf.lit('A'), psf.col('score'))
    }

    # withColumns takes are dictionary
    df = df.withColumns(cols)
    df.printSchema()
    df.show()
