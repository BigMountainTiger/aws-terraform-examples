import boto3
from botocore.exceptions import ClientError


def get_glue_table(database_name, table_name):
    try:
        glue_client = boto3.client('glue')
        response = glue_client.get_table(DatabaseName=database_name, Name=table_name)

        return response['Table']
    except ClientError as e:
        if e.response['Error']['Code'] == 'EntityNotFoundException':
            return None
        else:
            raise


def validate_existing_table_is_iceberg(glue_table):
    table_name = glue_table.get('Name')
    parameters = glue_table.get('Parameters', {})
    table_type = parameters.get('table_type') or parameters.get('TABLE_TYPE')
    classification = parameters.get('classification')

    is_iceberg = str(table_type).lower() == 'iceberg' or str(classification).lower() == 'iceberg'

    if not is_iceberg:
        raise RuntimeError(
            f"Glue table '{table_name}' already exists but is not registered as an Iceberg table."
            f"Current parameters: table_type={table_type}, classification={classification}."
        )
