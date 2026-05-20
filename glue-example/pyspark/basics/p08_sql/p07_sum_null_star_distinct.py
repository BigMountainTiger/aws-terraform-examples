import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T
import decimal

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("id", T.IntegerType())
    ])

    data = [
        {'id': 1},
        {'id': 1},
        {'id': 2},
        {'id': 2},
        {'id': None},
        {'id': None}
    ]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    df.createOrReplaceTempView('tv')

    def run_sql(sql):
        df = spark.sql(sql)
        print(sql)
        df.show()

    # * includes null rows
    run_sql('select count(*) from tv')

    # with column exclude null rows
    run_sql('select count(id) from tv')

    # with distinct column exclude rows and do a distinct count
    run_sql('select count(distinct id) from tv')
