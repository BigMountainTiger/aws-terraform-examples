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

    column_name = 'id'
    exits = column_name.lower() in (n.lower() for n in df.columns)
    print(f'column "{column_name}" exists = {exits}')

    column_name = 'ID'
    exits = column_name.lower() in (n.lower() for n in df.columns)
    print(f'column "{column_name}" exists = {exits}')

    column_name = 'Student'
    exits = column_name.lower() in (n.lower() for n in df.columns)
    print(f'column "{column_name}" exists = {exits}')

    print()

    column_name = 'IDs'
    exits = column_name.lower() in (n.lower() for n in df.columns)
    print(f'column "{column_name}" exists = {exits}')

    column_name = 'Students'
    exits = column_name.lower() in (n.lower() for n in df.columns)
    print(f'column "{column_name}" exists = {exits}')

    # Use set can improve performance
    print()
    print('Use set for fast checks')
    column_names = set((n.lower() for n in df.columns))

    column_name = 'ID'
    exits = column_name.lower() in column_names
    print(f'column "{column_name}" exists = {exits}')

    column_name = 'Students'
    exits = column_name.lower() in column_names
    print(f'column "{column_name}" exists = {exits}')
