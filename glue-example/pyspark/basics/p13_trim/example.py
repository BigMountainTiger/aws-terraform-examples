import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("id", T.StringType()),
        T.StructField("attribute", T.StringType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': 'A_1 ', 'attribute': None},
        {'id': 'A_2 ', 'attribute': 'attribute 1'},
    ])])
    df = spark.read.json(rdd, multiLine=True, schema=schema, mode='FAILFAST')
    df.show()

    print('Without trim()')
    df_filtered = df.filter(psf.col('id') == 'A_1')
    df_filtered.show()

    print('With trim()')
    df_filtered = df.filter(psf.trim(psf.col('id')) == 'A_1')
    df_filtered.show()

    print('Trim the whole column')
    df = df.withColumn('id', psf.trim(psf.col('id')))
    df.show()
