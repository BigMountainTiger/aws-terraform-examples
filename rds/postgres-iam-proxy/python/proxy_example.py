import boto3
import urllib
import psycopg
import threading
from functools import lru_cache

connection_lock = threading.Lock()


@lru_cache(maxsize=1)
def iam_token_dict(endpoint_address, username):

    result = {}
    rds_client = boto3.client('rds')
    try:

        aws_region = 'us-east-1'
        token = rds_client.generate_db_auth_token(
            DBHostname=endpoint_address, Port=5432, DBUsername=username, Region=aws_region)

        result = {
            'ENDPOINT': endpoint_address,
            'PORT': 5432,
            'USER': username,
            'REGION': aws_region,
            'TOKEN': token
        }

    finally:
        rds_client.close()

    return result


def connect(endpoint_address, username):
    with connection_lock:
        def _connect():
            d = iam_token_dict(endpoint_address, username)

            password_encoded = urllib.parse.quote_plus(d.get('TOKEN'))
            endpoint_port = d.get('PORT')
            db_name = 'experiment'
            CONSTR = f'postgres://{username}:{password_encoded}@{
                endpoint_address}:{endpoint_port}/{db_name}?sslmode=require'

            return psycopg.connect(CONSTR)

        try:
            conn = _connect()
        except Exception:
            iam_token_dict.cache_clear()
            conn = _connect()

        return conn


def make_a_query(sql, username):
    endpoint_address = "ok.proxy-cfa5drybscc2.us-east-1.rds.amazonaws.com"

    with connect(endpoint_address, username) as conn:
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
