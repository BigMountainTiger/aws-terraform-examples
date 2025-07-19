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
        {'student_name': 'Song Li', 'class_name': 'English', 'score': 99},
        {'student_name': 'Song Li', 'class_name': 'Science', 'score': 99},
        {'student_name': 'Trump', 'class_name': None, 'score': None},
        {'student_name': 'Trump', 'class_name': 'English', 'score': None}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    # Pass in the column name to fill only the selected column
    df_filled = df.fillna({'score': -1})
    df_filled.show()

    # Without columns the fill applies to all the columns of matching type
    # it is better to specify the column for safety
    df_filled = df.fillna(-1)
    df_filled.show()