# The exampe show how to
# 1. use additional_package
# 2. load local data
# in the local running mode through the docker container

from additional_package import additional_module
from pyspark.context import SparkContext
from awsglue.context import GlueContext

import sys

sc = SparkContext()
sc.setLogLevel('ERROR')

glueContext = GlueContext(sc)
spark = glueContext.spark_session


def run():
    print('Running')
    print(f'Python version - {sys.version}')
    additional_module.print_it()


if __name__ == '__main__':
    run()

    print()

    df = spark.read \
        .option('header', True) \
        .option('quote', '"') \
        .csv("data/data-000.csv")

    df.show()
