from pyiceberg.catalog import load_catalog
from pyiceberg.io.pyarrow import _pyarrow_to_schema_without_ids
from utils.pyarrow_util import PyArrowPandasDataframeGenerator

s3_bucket = "iceberg-example-huge-head-li"

s3_database_dir = f's3://{s3_bucket}/databases'
database_name = "iceberg_example"
table_name = "student"

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
arrow_schema = dataframe_generator.arrow_schema


def get_or_create_table(database_name, table_name, s3_database_dir, arrow_schema):
    catalog = load_catalog("glue_catalog", **{"type": "glue", "warehouse": s3_database_dir})
    catalog.create_namespace_if_not_exists(database_name)

    iceberg_schema = _pyarrow_to_schema_without_ids(arrow_schema)
    table_identifier = f"{database_name}.{table_name}"

    try:
        table = catalog.load_table(table_identifier)
        print(f"Table '{table_identifier}' already exists. Load existing table.")
    except Exception as e:
        table = catalog.create_table(identifier=table_identifier, schema=iceberg_schema)
        print(f"Table '{table_identifier}' created successfully.")

    return table

table = get_or_create_table(database_name, table_name, s3_database_dir, arrow_schema)
print(f"Table '{database_name}.{table_name}' is ready for use.")
