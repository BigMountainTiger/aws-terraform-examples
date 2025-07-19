import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': 1, 'student': 'Song'},
        {'id': 2, 'student': 'Trump'},
        {'id': 3, 'student': 'Biden'}
    ])])
    df_student = spark.read.json(rdd, multiLine=True, mode='FAILFAST')
    # df_student.show()

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_id': 1, 'score': 100},
        {'student_id': 2, 'score': 20},
        {'student_id': 4, 'score': 99},
    ])])
    df_student_score = spark.read.json(rdd, multiLine=True, mode='FAILFAST')

    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='left'
    ).select(df_student['*'], df_student_score['score'])
    df.show()

    # use coalesce to fill NULL values
    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='left'
    ).select(df_student['*'], psf.coalesce(df_student_score['score'], psf.lit(-1)).alias('score'))
    df.show()
