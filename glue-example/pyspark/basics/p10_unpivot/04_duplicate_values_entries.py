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
        {'student_name': 'Song Li', 'class_name': 'General', 'score': 1},
        {'student_name': 'Song Li', 'class_name': 'Math', 'score': 99},
        {'student_name': 'Song Li', 'class_name': 'English', 'score': 99},
        {'student_name': 'Song Li', 'class_name': 'Science', 'score': 99},
        {'student_name': 'Trump', 'class_name': 'General', 'score': 2},
        {'student_name': 'Trump', 'class_name': 'Math', 'score': 33},
        {'student_name': 'Trump', 'class_name': 'English', 'score': 33}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df = df.groupBy("student_name").pivot("class_name").agg(psf.max('score'))
    df.show()

    # If "values" list has duplicates, the result will have duplicate rows
    # There are 2 Math in the values list
    print('There are 2 Math in the values list, so duplicate rows introduced')
    df_unpivot = df.unpivot(
        ids=['student_name', 'General'],
        values=['Math', 'Math', 'English', 'Science', 'General'],
        variableColumnName='class_name',
        valueColumnName='score'
    )
    df_unpivot.show()

