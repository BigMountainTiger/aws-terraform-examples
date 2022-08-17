from pyspark.context import SparkContext
from awsglue.context import GlueContext


class GluePythonSampleTest:
    def __init__(self):
        sc = SparkContext.getOrCreate()
        sc.setLogLevel('ERROR')

        self.context = GlueContext(sc)

    def run(self):
        dyf = self.read_json(
            "s3://awsglue-datasets/examples/us-legislators/all/persons.json")

        df = dyf.toDF()
        df = df.limit(4)
        df = df.select('family_name', 'given_name', 'name')
        df = df.toDF('last_name', 'given_name', 'full_name')

        df.show()

        path = 's3://huge-head-li-2023-glue-example/example-data.csv'
        df.toPandas().to_csv(path, header=True, index=False)

        print(
            f'File written to {"s3://huge-head-li-2023-glue-example/example-data.csv"}')

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
    GluePythonSampleTest().run()
