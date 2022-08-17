from pyspark.context import SparkContext
from awsglue.context import GlueContext
from pyspark.sql import Row

sc = SparkContext.getOrCreate()
sc.setLogLevel('ERROR')

context = GlueContext(sc)
spark = context.spark_session

student = spark.createDataFrame([
    Row(id=1, name='Name No.1'),
    Row(id=2, name='Name No.2'),
    Row(id=3, name='Name No.3'),
    Row(id=4, name='Name No.4')
])

score = spark.createDataFrame([
    Row(id=1, score=100),
    Row(id=5, score=80)
])

student.show()
score.show()

print('inner')
df = student.alias('student').join(score.alias('score'), student.id == score.id, 'inner')
df.show()

print('full')
df = student.alias('student').join(score.alias('score'), student.id == score.id, 'full')
df.show()

print('left')
df = student.alias('student').join(score.alias('score'), student.id == score.id, 'left')
df.show()

print('right')
df = student.alias('student').join(score.alias('score'), student.id == score.id, 'right')
df.show()
