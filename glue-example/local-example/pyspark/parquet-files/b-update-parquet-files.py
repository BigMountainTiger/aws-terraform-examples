from pyspark.sql import SparkSession
from pyspark.sql import Row

spark = SparkSession.builder.appName('b-update-parquet-files').getOrCreate()
sc = spark.sparkContext
sc.setLogLevel('ERROR')


def run():

    FILE_PATH = 'data/bing_covid-19_data.parquet'

    print(f'Loading from local {FILE_PATH}')
    df = spark.read.parquet(FILE_PATH)
    print(f'Shape {(df.count(), len(df.columns))}')
    print(f'No. of partitions {df.rdd.getNumPartitions()}')

    df.createOrReplaceTempView('COVID_DATA')
    df_count = spark.sql(
        "SELECT country_region, count(*) ct FROM COVID_DATA GROUP BY country_region")

    df_count.show(10)

    rdd = sc.parallelize([('Turkey'), ('China')])
    df_country = rdd.map(Row('name')).toDF()
    df_country.createOrReplaceTempView('COUNTRY')
    df_country.show()

    # Inner join
    df = spark.sql(
        "SELECT COVID_DATA.* FROM COVID_DATA INNER JOIN COUNTRY WHERE COVID_DATA.country_region = COUNTRY.name")
    df.createOrReplaceTempView('COVID_DATA')
    df_count = spark.sql(
        "SELECT country_region, count(*) ct FROM COVID_DATA GROUP BY country_region")

    df_count.show(10)


if __name__ == "__main__":
    run()
