import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("student", T.StringType())
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {'id': None, 'student': 'X'},
        {'id': 1, 'student': 'Song'}
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    # dict
    d = {f.name:f.dataType for f in df.schema.fields}
    print(d)
    
    # set
    s = set([f.name for f in df.schema.fields])
    print(s)