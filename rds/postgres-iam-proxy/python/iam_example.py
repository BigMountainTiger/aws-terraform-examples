import boto3
import urllib
import psycopg
import threading
from functools import lru_cache

connection_lock = threading.Lock()


@lru_cache(maxsize=1)
def iam_token_dict(db_identifier, username):

    result = {}
    rds_client = boto3.client('rds')
    try:
        response = rds_client.describe_db_instances(
            DBInstanceIdentifier=db_identifier)

        instance = response.get('DBInstances')[0]
        endpoint = instance.get('Endpoint')
        endpoint_address = endpoint.get('Address')
        endpoint_port = endpoint.get('Port')

        aws_region = 'us-east-1'
        token = rds_client.generate_db_auth_token(
            DBHostname=endpoint_address, Port=endpoint_port, DBUsername=username, Region=aws_region)

        result = {
            'ENDPOINT': endpoint_address,
            'PORT': endpoint_port,
            'USER': username,
            'REGION': aws_region,
            'TOKEN': token
        }

    finally:
        rds_client.close()

    return result


def connect(db_identifier, username):
    with connection_lock:
        def _connect():
            d = iam_token_dict(db_identifier, username)

            password_encoded = urllib.parse.quote_plus(d.get('TOKEN'))
            endpoint_address = d.get('ENDPOINT')
            endpoint_port = d.get('PORT')
            db_name = 'experiment'
            CONSTR = f'postgres://{username}:{password_encoded}@{
                endpoint_address}:{endpoint_port}/{db_name}'

            return psycopg.connect(CONSTR)

        try:
            conn = _connect()
        except Exception:
            iam_token_dict.cache_clear()
            conn = _connect()

        return conn


def make_a_query(sql, username):
    db_identifier = "rds-postgres-example"

    with connect(db_identifier, username) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)
            result = cur.fetchall()

    return result


def run():

    sql = 'select * from public.student s;'

    # We can have multiple IAM users
    result = make_a_query(sql, 'iam_user_1')
    print(result)

    result = make_a_query(sql, 'iam_user_2')
    print(result)


if __name__ == '__main__':
    run()
