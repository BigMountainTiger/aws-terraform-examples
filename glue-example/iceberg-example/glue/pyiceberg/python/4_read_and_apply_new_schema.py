from utils.pyarrow_util import PyArrowPandasDataframeGenerator
import pyarrow as pa
from utils import pyiceberg_util


database_name = "iceberg_example"
table_name = "student"

table = pyiceberg_util.get_table(database_name, table_name)

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
tb = pa.Table.from_pandas(df, schema=dataframe_generator.arrow_schema)

print(tb.schema)
