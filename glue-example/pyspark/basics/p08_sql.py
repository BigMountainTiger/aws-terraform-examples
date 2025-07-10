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
        {'id': 4, 'score': 99},
    ])])
    df_student_score = spark.read.json(rdd, multiLine=True, mode='FAILFAST')


    df_student.createOrReplaceTempView('student')
    df_student_score.createOrReplaceTempView('student_score')

    sql = """
        select s.id, s.student, ss.score
        from student s full outer join student_score ss on s.id = ss.id
    """
    df = spark.sql(sql)
    df.printSchema()
    df.show()

    sql = """
        select s.id, s.student, ss.score
        from student s inner join student_score ss on s.id = ss.id
    """
    df = spark.sql(sql)
    df.printSchema()
    df.show()

    sql = """
        select s.id, s.student, ss.score
        from student s full outer join student_score ss on s.id = ss.id
        where s.id is not null and ss.id is not null
    """
    df = spark.sql(sql)
    df.printSchema()
    df.show()
