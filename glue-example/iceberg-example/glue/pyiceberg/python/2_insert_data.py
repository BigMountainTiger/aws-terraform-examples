from utils.pyarrow_util import PyArrowPandasDataframeGenerator
from utils import pyiceberg_util

s3_bucket = "iceberg-example-huge-head-li"
s3_athena_output_dir = f's3://{s3_bucket}/athena'

database_name = "iceberg_example"
table_name = "student"
s3_table_location = f's3://{s3_bucket}/tables/{database_name}.{table_name}'


schema_template = {
    "id": 0,
    "student": {
        "name": "",
        "score": 0,
        "hobbies": [""],
        "age": 0,
        "tags": {"": ""}
    }
}

dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)

pyiceberg_util.drop_table_if_exists(s3_athena_output_dir, database_name, table_name)
print(f"Table '{database_name}.{table_name}' dropped")

table = pyiceberg_util.get_or_create_table(database_name, table_name, dataframe_generator.arrow_schema, s3_table_location)
print(f"Table '{database_name}.{table_name}' is ready for use.")

# First batch
data = [
    {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
    {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
    {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
]
tb = dataframe_generator.generate_pyarrow_table(data)

with table.transaction() as tx:
    tx.append(tb)

print('Inserted the first batch')

# Second batch
data = [
    {"id": 4, "student": {"name": "David", "score": 100, "age": 20, "extra_field": "value"}},
    {"id": 5, "student": {"name": "Eve", "hobbies": []}},
    {"id": 6, "student": {"name": "Frank", "hobbies": ["hiking", "photography"]}},
    {"id": 7, "student": None},
    {"id": 8, "student": {}},
    {"id": 9},
    {"id": 10, "student": {"tags": {"key1": "value1", "key2": "value2"}}}

]
tb = dataframe_generator.generate_pyarrow_table(data)

with table.transaction() as tx:
    tx.append(tb)

print('Inserted the second batch')

# The upsert 3rd batch
data = [
    {"id": 1, "student": {"name": "Alice", "score": 100, "age": 20, "tags": {"Updated": "true"}}},
    {"id": 11, "student": {"tags": {"key1": "value1", "key2": "value2"}}}

]
tb = dataframe_generator.generate_pyarrow_table(data)

with table.transaction() as tx:
    tx.upsert(df=tb, join_cols=["id"])

print('Upserted the third batch')
