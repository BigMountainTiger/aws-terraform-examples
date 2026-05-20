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
        {'student_name': 'Trump', 'class_name': 'Math', 'score': 33},
        {'student_name': 'Trump', 'class_name': 'English', 'score': 33}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    # use pyspark syntax
    # spark syntax can be more concise
    # values is optional, if omitted, all values are included
    df_pivot = df.groupBy("student_name") \
        .pivot("class_name", values=['Math', 'English', 'Science']).agg(psf.max('score'))
    df_pivot.printSchema()
    df_pivot.show()

    # use sql syntax
    df.createOrReplaceTempView('student')
    sql = """
        select * from
        (
            select student_name, class_name, score from student
        ) s PIVOT (
            MAX(score) for class_name in (
                'Math',
                'English',
                'Science'
            )
        );
    """
    df_pivot = spark.sql(sql)
    df_pivot.printSchema()
    df_pivot.show()
