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
    df = df.groupBy("student_name").pivot("class_name").agg(psf.max('score'))
    df.show()

    # Unpivot transforms the pivoted data into the aggregated form
    df_unpivot = df.unpivot(
        ids=['student_name'],
        values=['Math', 'English'],
        variableColumnName='class_name',
        valueColumnName='score'
    )
    df_unpivot.show()

    # If the 'values' parameter is set to None, it means "ALL values"
    df_unpivot = df.unpivot(
        ids=['student_name'],
        values=None,
        variableColumnName='class_name',
        valueColumnName='score'
    )
    df_unpivot.show()

    # use sql syntax
    # values mandatory and not quoted
    df.createOrReplaceTempView('pivoted')
    sql = """
        select u.student_name, u.class_name, u.score
        from pivoted s
        unpivot
        (
            score for class_name in (Math, Science, English)
        ) u
    """
    df_unpivot = spark.sql(sql)
    df_unpivot.show()
