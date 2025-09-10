import json
from pyspark.sql import SparkSession
import pyspark.sql.functions as F
import pyspark.sql.types as T
import decimal

spark: SparkSession = SparkSession.builder.getOrCreate()
spark.sparkContext.setLogLevel('ERROR')

def set_context():

    schema = T.StructType([
        T.StructField("id", T.IntegerType()),
        T.StructField("type", T.StringType()),
        T.StructField("value", T.IntegerType())
    ])

    data = [
        {'id': 1, 'type': 'A', 'value': 4},
        {'id': 2, 'type': 'A', 'value': 6},
        {'id': 3, 'type': 'B', 'value': 2},
        {'id': 4, 'type': 'B', 'value': 3},
        {'id': 5, 'type': 'B', 'value': 5}
    ]

    rdd = spark.sparkContext.parallelize([json.dumps(data)])
    df = spark.read.json(rdd, multiLine=True, mode='FAILFAST', schema=schema)
    df.createOrReplaceTempView('temp_table')


if __name__ == '__main__':

    set_context()

    # Note: We do not have access to the temp_table dataframe by python scope
    sql = """
        select id, type, value,
        sum(value) over (partition by type) as type_sum,
        1.0 * value / sum(value) over (partition by type) as type_ratio
        from temp_table
        order by id, type
    """

    df = spark.sql(sql)
    df.printSchema()
    df.show()

    # We can check the temp views from the catalog
    print(spark.catalog.listTables())
    print(spark.catalog.tableExists('temp_table'))




