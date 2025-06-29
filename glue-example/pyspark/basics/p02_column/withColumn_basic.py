import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student_name", T.StringType()),
        T.StructField("score", T.IntegerType()),
        T.StructField("class_name", T.StringType())
    ])

    # The order of the columns is decided by the schema
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

    # For an existing column, withColumn does not change the column position
    df = df.withColumn('score', (psf.when(psf.col('score') == 99, None).otherwise(psf.col('score'))).cast('long'))
    df.printSchema()
    df.show()

    # If the column does not exist, it is added to the end of the dataframe
    df = df.withColumn('Another_column', psf.lit('default value'))
    df.printSchema()
    df.show()