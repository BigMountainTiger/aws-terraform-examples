import json
from pyspark.sql import SparkSession
import pyspark.sql.types as T
import pandas as pd

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

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)

    df.printSchema()
    df.show()

    # Because the id has null value, it is made to float type by pandas
    # int32 does not have NaN
    print('\n\n+++++++++++++++++++++++')
    pandas_df = df.toPandas()
    pandas_df.info()
    print(pandas_df)

    # We can explicitly cast it to nullable integer type by calling
    # convert_dtypes()
    # - Convert columns to the best possible dtypes using dtypes supporting "pd.NA".
    print('\n\n+++++++++++++++++++++++')
    pandas_df = pandas_df.convert_dtypes()
    pandas_df.info()
    print(pandas_df)

    # Calling convert_dtypes() multiple times is OK
    print('\n\n+++++++++++++++++++++++')
    print('Calling convert_dtypes() multiple times is OK')
    pandas_df = pandas_df.convert_dtypes()
    pandas_df.info()
    print(pandas_df)