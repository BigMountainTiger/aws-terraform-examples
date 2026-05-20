import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T
import decimal

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


# 1. ** Need to handle None input case, it is a REAL possibility that NULL is passed in
# 2. ** Make sure return the value of EXACT type as declare, otherwise pyspark treat the returnn value as NULL
# 3. Optionally it is good to validate the input type
# 4. No real generic type UDF available in pyspark
@F.udf(returnType=T.FloatType())
def udf_square(x):
    if x is None:
        return None

    if not isinstance(x, (int, float, decimal.Decimal)):
        raise TypeError(f'udf_square only supports numeric types, but {x} is is of type {type(x)}')

    return float(x**2)


spark.udf.register('udf_square', udf_square)


if __name__ == '__main__':

    df = spark.sql("select udf_square(NULL) as result")
    df.printSchema()
    df.show()

    df = spark.sql("select cast(udf_square(10.1) as int) as result")
    df.printSchema()
    df.show()
