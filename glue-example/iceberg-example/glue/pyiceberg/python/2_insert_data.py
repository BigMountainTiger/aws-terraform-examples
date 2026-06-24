from pyiceberg.catalog import load_catalog
from schema.pyarrow_util import PyArrowPandasDataframeGenerator

s3_bucket = "iceberg-example-huge-head-li"
s3_database_dir = f's3://{s3_bucket}/databases'

database_name = "iceberg_example"
table_name = "student"

catalog = load_catalog("glue_catalog", **{"type": "glue", "warehouse": s3_database_dir})
catalog.create_namespace_if_not_exists(database_name)

table_identifier = f"{database_name}.{table_name}"
table = catalog.load_table(table_identifier)

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

data = [
    {"id": 1, "student": {"name": "Alice", "score": 100, "hobbies": ["reading"]}},
    {"id": 2, "student": {"name": "Bob", "score": 90, "hobbies": ["gaming", "cooking"]}},
    {"id": 3, "student": {"name": "Charlie", "score": 80, "hobbies": ["hiking", "photography"]}}
]
tb = dataframe_generator.generate_pyarrow_table(data)

with table.transaction() as tx:
    tx.append(tb)


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
