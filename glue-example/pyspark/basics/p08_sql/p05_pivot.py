import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T
import decimal

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student_name", T.StringType()),
        T.StructField("class", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    data = [
        {'student_name': 'Song', 'class': 'Math', 'score': 100},
        {'student_name': 'Song', 'class': 'English', 'score': 100},
        {'student_name': 'Song', 'class': 'Science', 'score': 100},
        {'student_name': 'Trump', 'class': 'Math', 'score': 50},
        {'student_name': 'Trump', 'class': 'English', 'score': 50},
        {'student_name': 'Trump', 'class': 'What-ever', 'score': 50},
    ]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    df.createOrReplaceTempView('student')
    sql = """
        select * from
        (
            (
                select student_name, class, score
                from student
            ) pivot (
                max(score) for class in ('Math', 'English', 'Science')
            )
        )
        -- It is possible to add filters after the pivoting
        where Science is not NULL
        order by student_name
    """

    df_pivoted = spark.sql(sql)
    df_pivoted.show()

    # Simpler syntax
    sql = """
        select * from
        (
            select student_name, class, score
            from student
        ) pivot (
            max(score) for class in ('Math', 'English', 'Science')
        )
        -- It is possible to add filters after the pivoting
        where Science is not NULL
        order by student_name
    """

    df_pivoted = spark.sql(sql)
    df_pivoted.show()

