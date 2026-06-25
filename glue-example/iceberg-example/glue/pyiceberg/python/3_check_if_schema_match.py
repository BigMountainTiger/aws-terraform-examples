from pyiceberg.catalog import load_catalog
from pyiceberg.io.pyarrow import _pyarrow_to_schema_without_ids
from pyiceberg.schema import assign_fresh_schema_ids

from iceberg_evolve.schema import Schema
from iceberg_evolve.diff import SchemaDiff
from iceberg_evolve.renderer import SchemaDiffRenderer
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
new_schema = dataframe_generator.schema
new_schema = _pyarrow_to_schema_without_ids(new_schema)
new_schema = assign_fresh_schema_ids(new_schema)

table_schema = table.schema()

schema_match = (table_schema == new_schema)
print(f"Schema match: {schema_match}")