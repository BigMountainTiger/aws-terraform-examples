from pyiceberg.catalog import load_catalog
from schema.pyarrow_util import PyArrowPandasDataframeGenerator
import pyarrow as pa

s3_bucket = "iceberg-example-huge-head-li"
s3_database_dir = f's3://{s3_bucket}/databases'

database_name = "iceberg_example"
table_name = "student"

catalog = load_catalog("glue_catalog", type="glue", warehouse=s3_database_dir)
catalog.create_namespace_if_not_exists(database_name)

table_identifier = f"{database_name}.{table_name}"
table = catalog.load_table(table_identifier)

schema_template = {
    "id": 0,
    "student": {
        "name": "",
        "address": "",
        "score": 0,
        "hobbies": [""],
        "age": 0,
        "tags": {"": ""}
    }
}

dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)

df = table.scan().to_pandas()
tb = pa.Table.from_pandas(df, schema=dataframe_generator.schema)

print(tb.schema)
