from utils.pyarrow_util import PyArrowPandasDataframeGenerator
from utils import pyiceberg_util

s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/athena'

database_name = "iceberg_example"
table_name = "ids_table"
s3_table_location = f's3://{s3_bucket}/tables/{database_name}.{table_name}'


schema_template = {
    "id": 0
}

dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)

pyiceberg_util.drop_table_if_exists(s3_athena_output_dir, database_name, table_name)
print(f"Table '{database_name}.{table_name}' dropped")

table = pyiceberg_util.get_or_create_table(database_name, table_name, dataframe_generator.arrow_schema, s3_table_location)
print(f"Table '{database_name}.{table_name}' is ready for use.")

# First batch
data = [
    {"id": 1},
    {"id": 2},
    {"id": 3},
    {"id": 4}
]
tb = dataframe_generator.generate_pyarrow_table(data)

with table.transaction() as tx:
    tx.append(tb)

print('Inserted the first batch')
