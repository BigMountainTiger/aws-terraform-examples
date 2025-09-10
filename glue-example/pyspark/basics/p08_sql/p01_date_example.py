import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')

# In PySpark SQL, current_date and current_date() refer to the same function and provide the same functionality:
# returning the current date at the start of query evaluation. The use of parentheses () is optional.

# But when use pyspark.sql.functions.current_date function, need to use () to invoke the function to get the date object

if __name__ == '__main__':
    
    df = spark.sql("select current_date as current_date_value")
    df.printSchema()
    df.show()


    df = spark.sql("select current_date() as current_date_value")
    df.printSchema()
    df.show()

    print('There is no difference between current_date and current_date() when used in SQL expressions')

    print()
    print('___today____')
    df = spark.sql("select date(current_date()) as today")
    df.printSchema()
    df.show()

    print('___yesterday____')
    df = spark.sql("select date(dateadd(day, -1, current_date())) as today")
    df.printSchema()
    df.show()


    print('___first day of the month____')
    df = spark.sql("select date(date_trunc('month', current_date())) as today")
    df.printSchema()
    df.show()


    print('___first day of the year____')
    df = spark.sql("select date(date_trunc('year', current_date())) as today")
    df.printSchema()
    df.show()