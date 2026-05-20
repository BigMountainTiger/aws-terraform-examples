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
        {'id': 1, 'score': 100},
        {'id': 2, 'score': 20},
        {'id': 4, 'score': 99},
    ])])
    df_student_score = spark.read.json(rdd, multiLine=True, mode='FAILFAST')

    # both "id" columns will be available in the 'df_join'
    df_join = df_student.join(
        df_student_score, (df_student['id'] == df_student_score['id']), how='outer'
    )
    df_join.printSchema()
    df_join.show()

    # +----+-------+----+-----+
    # |  id|student|  id|score|
    # +----+-------+----+-----+
    # |   1|   Song|   1|  100|
    # |   2|  Trump|   2|   20|
    # |   3|  Biden|NULL| NULL|
    # |NULL|   NULL|   4|   99|
    # +----+-------+----+-----+

    # Because two 'id' columns in the dataframe,
    # the follow gets a RUN-TIME error
    # df = df_join.select('id')

    # Need to use the dataframe name to specify which 'id' is selected
    df = df_join.select(df_student['*'], df_student_score['score'])
    df.show()

    df = df_join.select(df_student['student'], df_student_score['*'])
    df.show()

    # alias the column names
    df = df_join.select(df_student['*'], df_student['id'].alias('df_student_id'), df_student_score['*'], df_student_score['id'].alias('df_student_score_id'))
    df = df.drop(*[df_student['id'], df_student_score['id']])
    df.show()
