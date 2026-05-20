import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    data = [
        {'id': None, 'student': 'X', 'math': 100, 'english': 90},
        {'id': 1, 'student': 'Song', 'math': 100, 'english': 61},
        {'id': 2, 'student': 'Trump', 'math': 20, 'english': 100},
        {'id': 3, 'student': 'Biden', 'math': 20, 'english': 100}
    ]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST')
    df.show()

    # select
    columns = [
        psf.col('id'),
        psf.col('student'),
        psf.col('math'),
        psf.col('english')
    ]

    avg = (psf.col('math') + psf.col('english'))/2.0
    columns.append(
        # The order of the when conditions is important
        psf.when(avg > 90.0, 'GOOD').when(avg > 80.0, 'OK').otherwise('BAD').alias('evaluation')
    )

    df_selected = df.select(*columns)
    df_selected.show()
