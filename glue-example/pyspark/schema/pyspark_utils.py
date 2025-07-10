import boto3
import json
import pyspark.sql.types as T


def generate_schema_from_json_data(data):
    return generate_schema(None, data)


def generate_self_referenced_schema_from_json_data(data, referencing_field, no_of_layers=3):
    schema = generate_schema_from_json_data(data)
    for _ in range(0, no_of_layers - 1):
        parent_schema = generate_schema_from_json_data(data)

        for field in parent_schema.fields:
            if field.name == referencing_field:
                field.dataType = schema
                break

        schema = parent_schema

    return schema


def generate_schema(key, value):

    if key is None:
        if isinstance(value, bool):
            return T.BooleanType()
        elif isinstance(value, float):
            return T.DoubleType()
        elif isinstance(value, int):
            return T.LongType()
        if isinstance(value, str):
            return T.StringType()
        elif isinstance(value, dict):
            dict_keys = list(value.keys())
            if len(dict_keys) == 0:
                raise Exception(f'Empty dictionary (StructType fields) is not allowed in pyspark schema {value}')

            if len(dict_keys) == 1 and dict_keys[0].strip() == '':
                return T.MapType(T.StringType(), generate_schema(None, value[dict_keys[0]]))
            else:
                type_list = []
                for k, v in value.items():
                    if k.strip() == '':
                        raise Exception(f'Empty dictionary key in {value}')

                    type_list.append(generate_schema(k, v))

                return T.StructType(type_list)

        elif isinstance(value, list):
            if len(value) == 0:
                raise Exception(f'Empty list (unable to get the type of an empty list) is not allowed in pyspark schema {value}')

            return T.ArrayType(generate_schema(None, value[0]))
        else:
            raise Exception(f'The type of {value} - {type(value)} is not supported')

    return T.StructField(key, generate_schema(None, value), True)


def save_schema(schema, path, indent=2):
    with open(path, 'w') as f:
        f.write(json.dumps(schema.jsonValue(), indent=indent))


def load_schema(path, bucket=None):
    def read_s3_file(path):
        s3_client = boto3.client('s3')
        data = s3_client.get_object(Bucket=bucket, Key=path)
        content = data['Body'].read()
        return content.decode("utf-8")

    def read_local_file(path):
        with open(path, 'r') as file:
            content = file.read()
        return content

    func = read_local_file if bucket is None else read_s3_file
    return T.StructType.fromJson(json.loads(func(path)))