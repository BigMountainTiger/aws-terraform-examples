import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from pyspark.sql import SQLContext

sc = SparkContext()
sc.setLogLevel('ERROR')

glueContext = GlueContext(sc)
spark = glueContext.spark_session

URL = 'jdbc:postgresql://experiment-postgres.cfa5drybscc2.us-east-1.rds.amazonaws.com:5432/experiment'
USR = 'song'
PWD = 'PWD-1234'

df = spark.read.format('jdbc') \
    .option('url', f'{URL}?user={USR}&password={PWD}') \
    .option('dbtable', '(select * from public.student where id = 2) student') \
    .load()

df.show()

df = spark.read.format('jdbc') \
    .option('url', f'{URL}?user={USR}&password={PWD}') \
    .option('dbtable', 'public.student') \
    .load()

df.show()


df.write.format('jdbc').mode('overwrite') \
    .option('url', f'{URL}?user={USR}&password={PWD}') \
    .option('dbtable', 'public.student_dump') \
    .save()

print('Done')
