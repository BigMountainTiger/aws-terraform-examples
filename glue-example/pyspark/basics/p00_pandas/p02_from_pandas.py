from pyspark.sql import SparkSession
import pyspark.sql.types as T
import pyspark.sql.functions as psf
import pandas as pd

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')

D = {
    'id': [None, 0, 1],
    'name': ['nobody', 'Song', 'Biden'],
    'score': [10, 100, 10]
}

pandas_df = pd.DataFrame(D)

print('\n\n++++++++++++++++++++++++++')
print('Before convert_dtypes()')
df = spark.createDataFrame(pandas_df)
df.printSchema()
df.show()


print('\n\n++++++++++++++++++++++++++')
print('After convert_dtypes()')

pandas_df = pandas_df.convert_dtypes()
print('pandas dtypes')
print(pandas_df.dtypes)
print(pandas_df)


print()
print('pyspark types')
# It looks like pyspark does not honor pandas convert_dtypes() when createDataFrame()
df = spark.createDataFrame(pandas_df)
df.printSchema()
df.show()


print()
print('Explicit cast')
# When explicit cast, need to take care of "isnan", otherwise NaN may be converted to 0
df = df.withColumn('id', psf.when(psf.isnan('id'), None).otherwise(psf.col('id')).cast(T.LongType()))
df.printSchema()
df.show()

