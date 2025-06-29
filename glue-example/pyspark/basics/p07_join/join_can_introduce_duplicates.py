import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': 1, 'student': 'Song'},
        {'id': 2, 'student': 'Trump'},
        {'id': 3, 'student': 'Biden'}
    ])])
    df_student = spark.read.json(rdd, multiLine=True, mode='FAILFAST')

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': 1, 'score': 100},
        {'id': 2, 'score': 20},
        {'id': 2, 'score': 10},
    ])])
    df_student_score = spark.read.json(rdd, multiLine=True, mode='FAILFAST')

    # join can inroduce duplicates
    df_join = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['id']), how='inner'
    )
    df_join.printSchema()
    df_join.show()

    print('Trump is duplicated')
    df_join = df_join.select(df_student['id'], 'student')
    df_join.show()
