from pyiceberg.catalog import load_catalog
from pyiceberg.io.pyarrow import _pyarrow_to_schema_without_ids
from .athena_client import AthenaClient


def drop_table_if_exists(s3_athena_output_dir, database_name, table_name):
    athena_client = AthenaClient(s3_athena_output_dir=s3_athena_output_dir)
    athena_client.execute_sql_query(f"DROP TABLE IF EXISTS {database_name}.{table_name};")


def create_database_if_not_exists(database_name):
    catalog = load_catalog("glue_catalog", **{"type": "glue"})
    catalog.create_namespace_if_not_exists(database_name)


def get_or_create_table(database_name, table_name, arrow_schema, s3_table_location):
    catalog = load_catalog("glue_catalog", **{"type": "glue"})

    iceberg_schema = _pyarrow_to_schema_without_ids(arrow_schema)
    table_identifier = f"{database_name}.{table_name}"

    try:
        table = catalog.load_table(table_identifier)
        print(f"Table '{table_identifier}' already exists. Load existing table.")
    except Exception as e:
        table = catalog.create_table(identifier=table_identifier, schema=iceberg_schema, location=s3_table_location)
        print(f"Table '{table_identifier}' created successfully.")

    return table


def get_table(database_name, table_name):
    catalog = load_catalog("glue_catalog", **{"type": "glue"})
    table_identifier = f"{database_name}.{table_name}"
    table = catalog.load_table(table_identifier)

    return table
