import json
from itertools import chain
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student", T.IntegerType()),
        T.StructField("score", T.IntegerType()),
        T.StructField("class_name", T.StringType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student': 1, 'class_name': 'Math', 'score': 99},
        {'student': 2, 'class_name': 'Math', 'score': 33},
        {'student': 3, 'class_name': 'English', 'score': 40},
        {'student': None, 'class_name': 'Non-exist', 'score': 100}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.printSchema()
    df.show()

    # Create a map
    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("name", T.StringType())
    ])
    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': 1, 'name': 'Song'},
        {'id': 2, 'name': 'Trump'}
    ])])
    df_name = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    names = list(chain.from_iterable([[r.id, r.name] for r in df_name.select('id', 'name').collect()]))
    name_map = psf.create_map([psf.lit(n) for n in names])


    # Look up from the map
    print('The type of the student column is integer before withColumn()')
    print('The type of the student column becomes string after the withColumn() and the map look up')
    df = df.withColumn('student', name_map[psf.col('student')])
    df.printSchema()
    df.show()
