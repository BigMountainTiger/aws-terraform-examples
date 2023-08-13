import json
import boto3
import urllib
from functools import lru_cache


@lru_cache(maxsize=1)
def get_conn_string(rds_id, db_name):

    rds_client = boto3.client('rds')
    sm_client = boto3.client('secretsmanager')

    try:
        response = rds_client.describe_db_instances(
            DBInstanceIdentifier=rds_id)

        instance = response.get('DBInstances')[0]
        endpoint = instance.get('Endpoint')
        endpoint_address = endpoint.get('Address')
        endpoint_port = endpoint.get('Port')
        master_user_secret_arn = instance.get(
            'MasterUserSecret').get('SecretArn')

        response = sm_client.get_secret_value(SecretId=master_user_secret_arn)

        secret_string = response.get('SecretString')
        secret = json.loads(secret_string)
        username = secret.get('username')
        password = secret.get('password')

    finally:
        rds_client.close()
        sm_client.close()

    password_encoded = urllib.parse.quote_plus(password)
    return f'postgres://{username}:{password_encoded}@{endpoint_address}:{endpoint_port}/{db_name}'
