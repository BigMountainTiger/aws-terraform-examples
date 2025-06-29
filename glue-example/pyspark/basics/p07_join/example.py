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
    # df_student.show()

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_id': 1, 'score': 100},
        {'student_id': 2, 'score': 20},
        {'student_id': 4, 'score': 99},
    ])])
    df_student_score = spark.read.json(rdd, multiLine=True, mode='FAILFAST')
    # df_student_score.show()

    # inner join
    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='inner'
    ).select(df_student['*'], df_student_score['score'])
    df.printSchema()
    df.show()

    # left join
    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='left'
    ).select(df_student['*'], df_student_score['score'])
    df.printSchema()
    df.show()

    # outer join
    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='outer'
    ).select(df_student['*'], df_student_score['score'])
    df.printSchema()
    df.show()

    # join and filter and then select
    df = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['student_id']), how='outer'
    ).filter(df_student['id'].isNotNull() & df_student_score['student_id'].isNotNull()) 
    df = df.select(df_student['*'], df_student_score['score'].alias('final_score'))

    df.printSchema()
    df.show()