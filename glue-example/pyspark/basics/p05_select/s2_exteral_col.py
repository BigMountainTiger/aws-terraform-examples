import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    data = [
        {'id': None, 'student': 'X', 'score': 100},
        {'id': 1, 'student': 'Song', 'score': 100},
        {'id': 2, 'student': 'Trump', 'score': 20},
        {'id': 3, 'student': 'Biden', 'score': 20}
    ]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST')
    df.show()

    # select
    columns = [
        psf.col('id'),
        psf.col('student').alias('student_name'),
        psf.col('score').cast('long')
    ]

    df_selected = df.select(*columns)
    df_selected.show()

    columns.append(
        psf.concat(psf.lit('A-'), psf.col('score')).cast('string').alias('new_score')
    )

    df_selected = df.select(*columns)
    df_selected.show()
