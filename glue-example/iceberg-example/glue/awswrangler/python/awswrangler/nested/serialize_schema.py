import json
import pyarrow as pa

def serialize_arrow_type(arrow_type):
    """Recursively processes Arrow data types into a serializable format."""
    # Check for nested Struct type
    if isinstance(arrow_type, pa.StructType):
        return {
            "type": "struct",
            "fields": {arrow_type[i].name: serialize_arrow_type(arrow_type[i].type) for i in range(arrow_type.num_fields)}
        }
    # Check for List type
    elif isinstance(arrow_type, pa.ListType):
        return {
            "type": "list",
            "value_type": serialize_arrow_type(arrow_type.value_type)
        }
    # Fallback for primitive types
    return str(arrow_type)

# Define a complex nested schema
complex_schema = pa.schema([
    pa.field('id', pa.int64()),
    pa.field('profile', pa.struct([
        pa.field('email', pa.string()),
        pa.field('age', pa.int32())
    ])),
    pa.field('tags', pa.list_(pa.string()))
])

# Build the complete dictionary mapping
full_schema_dict = {field.name: serialize_arrow_type(field.type) for field in complex_schema}

# Convert to JSON string
json_complex_schema = json.dumps(full_schema_dict, indent=4)
print(json_complex_schema)
