import json
import logging
import pyarrow as pa
import pandas as pd

logger = logging.getLogger()


class PyArrowSchemaGenerator:

    def print_schema(self, schema):
        for s in schema.to_string().split('\n'):
            if not s.startswith((' ', '\t')):
                logger.info(s)

    def generate_schema(self, schema_template):

        def pyarrow_type(data):

            if isinstance(data, bool):
                return pa.bool_()
            elif isinstance(data, float):
                return pa.float64()
            elif isinstance(data, int):
                return pa.int64()
            elif isinstance(data, str):
                return pa.string()
            elif isinstance(data, dict):
                if not data:
                    raise TypeError("The dictionaries in the schema template must be non-empty")

                if "" in data:
                    if len(data) > 1:
                        raise TypeError("A dictionary in the schema template can not have both empty and non-empty keys")

                    return pa.map_(pa.string(), pyarrow_type(data[""]))

                return pa.struct([
                    pa.field(key, pyarrow_type(value))
                    for key, value in data.items()
                ])

            elif isinstance(data, list):
                if len(data) != 1:
                    raise TypeError(f"A list in the schema template must have exactly one element {data}")

                return pa.list_(pyarrow_type(data[0]))

            else:
                raise TypeError(f"Unsupported data type: {type(data)} for data {data}")

        # Generate the schema
        if not isinstance(schema_template, dict) or not schema_template:
            raise TypeError("The schema template must be a non-empty dictionary")

        if any(not k for k in schema_template):
            raise TypeError("All keys in the schema template must be non-empty strings")

        return pa.schema([
            pa.field(key, pyarrow_type(value))
            for key, value in schema_template.items()
        ])


class PyArrowPandasDataframeGenerator:

    def __init__(self, schema_template):
        self._schema = None
        self.schema_template = schema_template
        self.pyarrow_schema_generator = PyArrowSchemaGenerator()

    @property
    def schema(self):
        if self._schema is None:
            self._schema = self.pyarrow_schema_generator.generate_schema(self.schema_template)

        return self._schema

    def print_schema(self):
        self.pyarrow_schema_generator.print_schema(self.schema)

    def generate_pyarrow_table(self, data):
        table = pa.Table.from_pylist(data, schema=self.schema)
        return table

    def generate_dataframe(self, data):
        table = self.generate_pyarrow_table(data)
        return table.to_pandas(types_mapper=pd.ArrowDtype)


def create_dataframe_generator(schema_file_path):
    with open(schema_file_path, 'r') as f:
        schema_template = json.load(f)

    dataframe_generator = PyArrowPandasDataframeGenerator(schema_template)

    return dataframe_generator
