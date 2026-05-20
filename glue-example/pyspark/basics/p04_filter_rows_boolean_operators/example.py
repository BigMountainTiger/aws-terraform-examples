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

    # 1. Single '&' is for 'and'
    # 2. Explict () may be needed, ie. "(df['score'] > 50)""
    sub_df = df.filter((df['score'] > 50) & df['id'].isNotNull())
    sub_df.printSchema()
    sub_df.show()

    # or is |
    sub_df = df.filter((psf.col('score') < 50) | (psf.col('id').isNull()))
    sub_df.printSchema()
    sub_df.show()

    # ~ is negation, () may be needed to make sure what is being negated
    sub_df = df.filter(~((psf.col('score') < 50) | (psf.col('id').isNull())))
    sub_df.printSchema()
    sub_df.show()
