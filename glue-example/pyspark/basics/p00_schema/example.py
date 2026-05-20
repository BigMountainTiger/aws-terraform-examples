import json
from pyspark.sql import SparkSession
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')

if __name__ == '__main__':

    data = [
        {'id': None, 'student': 'X', 'score': 100},
        {'id': 1, 'student': 'Song', 'score': 100},
        {'id': 2, 'student': 'Trump', 'score': 20},
        {'id': 3, 'student': 'Biden', 'score': 20}
    ]

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("student", T.StringType()),
        T.StructField("score", T.IntegerType())
    ])

    # without given a schema, pyspark can infer the schema from the data
    # but the columns are ordered alphabetically
    # If a schema is given, the column order is defined by the schema
    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    df.printSchema()
    df.show()
