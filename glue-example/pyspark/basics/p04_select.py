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

    # select
    df_selected = df.select('id', 'student')
    df_selected.printSchema()
    df_selected.show()

    # select by list of column names
    column_name = ['student', 'score']
    df_selected = df.select(*column_name)
    df_selected.printSchema()
    df_selected.show()