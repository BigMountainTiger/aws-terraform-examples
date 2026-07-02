from utils.pyarrow_util import PyArrowPandasDataframeGenerator
from utils import pyiceberg_util

s3_bucket = "iceberg-example-huge-head-li"
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
arrow_schema = dataframe_generator.arrow_schema


table = pyiceberg_util.get_or_create_table(database_name, table_name, arrow_schema, s3_table_location)
print(f"Table '{database_name}.{table_name}' is ready for use.")
