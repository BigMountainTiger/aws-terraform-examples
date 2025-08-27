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

    print('Did not see any difference')