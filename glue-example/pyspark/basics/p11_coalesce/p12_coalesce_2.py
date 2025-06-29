import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("id_1", T.IntegerType()),
        T.StructField("id_2", T.IntegerType()),
        T.StructField("attribute", T.StringType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id_1': None, 'id_2': None, 'attribute': None},
        {'id_1': 1, 'id_2': None, 'attribute': 'attribute 1'},
        {'id_1': None, 'id_2': 2, 'attribute': 'attribute 2'},
        {'id_1': 3, 'id_2': None, 'attribute': 'attribute 3'}
    ])])
    df = spark.read.json(rdd, multiLine=True, schema=schema, mode='FAILFAST')
    df.show()

    df = df.groupBy('id_1', 'id_2').agg(
        psf.max('attribute').alias('attribute')
    )
    df.show()

    df = df.filter((psf.col('id_1').isNotNull() | psf.col('id_2').isNotNull()))
    df.show()

    # coalesce on 2 columns
    df = df.select(
        psf.coalesce(psf.col('id_1'), psf.col('id_2')).alias('id'),
        psf.col('attribute').cast('string')
    )
    df.show()

    df = df.sort(psf.col("id").asc())
    df.show()
