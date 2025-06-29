import json
from itertools import chain
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student_id", T.IntegerType()),
        T.StructField("score", T.IntegerType()),
        T.StructField("class_name", T.StringType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'student_id': 1, 'class_name': 'Math', 'score': 99},
        {'student_id': 1, 'class_name': 'English', 'score': 98},
        {'student_id': 1, 'class_name': 'Science', 'score': 97},
        {'student_id': 2, 'class_name': 'Math', 'score': 33},
        {'student_id': 2, 'class_name': 'English', 'score': 33},
        {'student_id': 3, 'class_name': 'English', 'score': 40},
        {'student_id': None, 'class_name': 'Non-exist', 'score': 100}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
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
    df_name.show()

    # create a list
    # Duplicate map key is a run-time error (same id show up more than once)
    names = list(chain.from_iterable([[r.id, r.name] for r in df_name.select('id', 'name').collect()]))
    name_map = psf.create_map([psf.lit(n) for n in names])

    # Look up
    # 1. If not found, value will be null
    # 2. It is OK if the key is NULL (i.e. null student_id)
    df = df.withColumn('student_name', name_map[psf.col('student_id')].cast('string'))
    df.show()
