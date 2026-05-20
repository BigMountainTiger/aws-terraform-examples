import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T
import decimal

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    data = [
        {'id': None, 'student': 'X', 'score': 100},
        {'id': 1, 'student': 'Song', 'score': 100},
        {'id': 2, 'student': 'Trump', 'score': 20},
        {'id': 3, 'student': 'Biden', 'score': 20},
        {'id': 4, 'student': 'nobody', 'score': 0}
    ]

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("student", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    df.printSchema()
    df.show()

    df = df.createOrReplaceTempView('student')

    sql = """
        with non_null_student (
            select * from student where id is not NULL
        ), good_studnt (
            select * from non_null_student where score > 0
        )
        select * from good_studnt
    """
    df = spark.sql(sql)
    df.show()
