import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
import pyspark.sql.types as T

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')


if __name__ == '__main__':

    schema = T.StructType([
        T.StructField("student_name", T.StringType()),
        T.StructField("Math", T.IntegerType()),
        T.StructField("English", T.IntegerType()),
        T.StructField("Science", T.IntegerType()),
    ])

    rdd = spark.sparkContext.parallelize([json.dumps([
        {
            'student_name': 'Song Li',
            'Math': 90,
            'English': 80,
            'Science': 70
        }
    ])])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.show()

    # It is OK to include all the columns in the ids and still do unpivoting
    df_unpivot = df.unpivot(
        variableColumnName='class_name',
        valueColumnName='score',
        ids=['student_name', 'Math', 'English', 'Science'],
        values=['Math', 'English', 'Science']
    )
    df_unpivot.show()


    # An exception is thrown -
    # if the values list has an enty that does not exist in the column list of the original dataframe
