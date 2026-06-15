from pyarrow_util import PyArrowSchemaGenerator

schema_template = {
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
    "tags": {
        "": ""
    },
    "orders": [
        {
            "order_id": 5002,
            "amount": 250.75
        }
    ]
}


# Generate and print the schema
pyarrow_schema_generator = PyArrowSchemaGenerator()
schema = pyarrow_schema_generator.generate_schema(schema_template)
pyarrow_schema_generator.print_schema(schema)