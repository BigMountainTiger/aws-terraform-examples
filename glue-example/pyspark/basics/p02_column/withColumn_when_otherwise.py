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
        T.StructField("str_score", T.StringType())
    ])

    # The order of the columns is decided by the schema
    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_name': 'Song Li', 'str_score': 'A99', 'score': 99},
        {'student_name': 'Song Li', 'str_score': 'A98', 'score': 98},
        {'student_name': 'Song Li', 'str_score': '98', 'score': 98},
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.printSchema()
    df.show()

    columns_to_set = [
        'score',
        'str_score'
    ]

    for c in columns_to_set:
        # cast() and astype() are essentially the same for changing the data type of a column.
        # when() function can be chained
        df = df.withColumn(c, (psf.when(psf.col(c).astype('string') == '98', None).otherwise(psf.col(c))))

    df.show()
