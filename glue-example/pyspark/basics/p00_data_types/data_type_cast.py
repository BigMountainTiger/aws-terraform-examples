import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T
import pyspark.sql as ps

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
    df.show()

    df.printSchema()

    # cast column to string is allowed
    df = df.withColumn("score", psf.col("score").cast(T.StringType()))
    df.show()

    df.printSchema()

    # cast all fields to desired types, if extra fields exist, exception will be raised
    def match_schema(df: ps.DataFrame, schema: T.StructType) -> ps.DataFrame:
        target_table_fields = {f.name.lower(): f.dataType for f in schema.fields}

        for c in [f.name.lower() for f in df.schema.fields]:
            df = df.withColumn(c, psf.col(c).cast(target_table_fields[c]))

        return df

    df = match_schema(df, schema)

    df.show()
    df.printSchema()

    # cast all fields to desired types
    # 1. If a field exists in the dataframe but not in schema, it will be dropped
    # 2. If a field exists in the schema but not in dataframe, it will be filled with null
    def match_schema_with_null_fill(df: ps.DataFrame, schema: T.StructType) -> ps.DataFrame:
        table_fields = {f.name.lower() for f in df.schema.fields}
        target_table_fields = {f.name.lower(): f.dataType for f in schema.fields}

        for c in table_fields:
            df = df if c in target_table_fields else df.drop(c)

        for c, t in target_table_fields.items():
            df = df.withColumn(c, psf.col(c).cast(t)) if c in table_fields else df.withColumn(c, psf.lit(None).cast(t))

        return df

    # add an extra field to the dataframe to test it will be dropped
    df = df.withColumn("extra_field", psf.lit("extra_value"))
    # cast id to string to test it will be cast back to int
    df = df.withColumn("id", psf.col("id").cast(T.StringType()))
    # add an extra field to the schema to test it will be filled with null
    schema.add(T.StructField("new_field", T.StringType()))

    df = match_schema_with_null_fill(df, schema)

    df.show()
    df.printSchema()
