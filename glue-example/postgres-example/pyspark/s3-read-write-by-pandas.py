from pyspark.context import SparkContext
from awsglue.context import GlueContext

import boto3


def list_buckets():
    session = boto3.session.Session()
    s3_client = session.client('s3')
    response = s3_client.list_buckets()
    buckets = []

    for bucket in response['Buckets']:
        buckets += {bucket["Name"]}

    print(buckets)


class GluePythonSampleTest:
    def __init__(self):

        sc = SparkContext.getOrCreate()
        sc.setLogLevel('ERROR')

        self.context = GlueContext(sc)

    def run(self):
        df = self.read_json(
            "s3://awsglue-datasets/examples/us-legislators/all/persons.json")

        # df.printSchema()
        df = df.select_fields(('family_name', 'name'))
        df = df.toDF()
        df.show()
        print((df.count(), len(df.columns)))

        df.toPandas().to_csv("s3://huge-head-li-2023-glue-example/student.csv",
                             header=True, index=False)

        print('Done writing csv to s3')

        df = self.context.read \
            .format('csv')\
            .option('header', 'true') \
            .load('s3://huge-head-li-2023-glue-example/student.csv')

        print('Loaded dataframe from csv')
        df.show()

        df.toPandas().to_parquet(
            's3://huge-head-li-2023-glue-example/student.parquet', compression='gzip')
        print('Done writing parquet to s3')

        df = self.context.read \
            .format('parquet') \
            .load('s3://huge-head-li-2023-glue-example/student.parquet')

        print('Loaded dataframe from parquet')
        df.show()
        print((df.count(), len(df.columns)))

        print()
        print('Filter by df["family_name"] == "Collins"')
        df = df.where(df["family_name"] == "Collins")
        df.show()
        print((df.count(), len(df.columns)))

    def read_json(self, path):
        dynamicframe = self.context.create_dynamic_frame.from_options(
            connection_type='s3',
            connection_options={
                'paths': [path],
                'recurse': True
            },
            format='json'
        )

        return dynamicframe


if __name__ == '__main__':
    list_buckets()
    GluePythonSampleTest().run()
