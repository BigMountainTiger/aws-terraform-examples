import pyarrow as pa

def infer_pyarrow_type(data):
    """Recursively infers PyArrow types from nested Python data structures."""
    if isinstance(data, dict):
        # Recursively build fields for the StructType
        fields = [
            pa.field(key, infer_pyarrow_type(value)) 
            for key, value in data.items()
        ]
        return pa.struct(fields)
    
    elif isinstance(data, list):
        if not data:
            # Handle empty list default
            return pa.list_(pa.null())
        # Infer type from the first element of the list
        return pa.list_(infer_pyarrow_type(data[0]))
    
    elif isinstance(data, int):
        return pa.int64()
    elif isinstance(data, float):
        return pa.float64()
    elif isinstance(data, bool):
        return pa.bool_()
    elif isinstance(data, str):
        return pa.string()
    elif data is None:
        return pa.null()
    else:
        raise TypeError(f"Unsupported data type: {type(data)}")

def generate_schema(sample_dict):
    """Generates a top-level PyArrow Schema from a root dictionary."""
    fields = [
        pa.field(key, infer_pyarrow_type(value)) 
        for key, value in sample_dict.items()
    ]
    return pa.schema(fields)

# ==========================================
# Example Usage
# ==========================================
nested_sample = {
    "user_id": 101,
    "username": "alice_dev",
    "is_active": True,
    "profile": {
        "first_name": "Alice",
        "last_name": "Smith",
        "metrics": {
            "score": 94.5,
            "rank": 3
        }
    },
    "tags": ["admin", "developer"],
    "orders": [
        {
            "order_id": 5001,
            "amount": 250.75
        }
    ]
}

# Generate and print the schema
schema = generate_schema(nested_sample)
print(schema)
