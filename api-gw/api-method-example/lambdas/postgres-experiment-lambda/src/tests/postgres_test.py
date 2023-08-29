import unittest
import json
import boto3
import urllib
import psycopg2


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


def db_connection_test():

    conn = None
    try:
        conn_str = get_conn_string('rds-postgres-example', 'experiment')
        print(conn_str)

        # 1. If connection string is not correct, the connect method raises an exception
        # 2. A connnection object can be closed multiple times silently
        conn = psycopg2.connect(conn_str)
        print(conn)
        print(f'Connection is closed {conn.closed}')
        
    except:

        print('Exception happened')
        raise

    finally:
        if conn is not None:
            conn.close()


class TestLambdafunction(unittest.TestCase):

    db_connection_test()
