from pyiceberg.io.pyarrow import _pyarrow_to_schema_without_ids
from pyiceberg.schema import assign_fresh_schema_ids
from utils.pyarrow_util import PyArrowPandasDataframeGenerator
from utils import pyiceberg_util

database_name = "iceberg_example"
table_name = "student"

table = pyiceberg_util.get_table(database_name, table_name)

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
new_schema = dataframe_generator.arrow_schema
new_schema = _pyarrow_to_schema_without_ids(new_schema)
new_schema = assign_fresh_schema_ids(new_schema)

table_schema = table.schema()

schema_match = (table_schema == new_schema)
print(f"Schema match: {schema_match}")
