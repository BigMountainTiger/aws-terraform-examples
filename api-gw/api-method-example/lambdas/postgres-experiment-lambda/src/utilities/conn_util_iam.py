# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.IAMPolicy.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.DBAccounts.html#UsingWithRDS.IAMDBAuth.DBAccounts.PostgreSQL


import boto3
from functools import lru_cache


@lru_cache(maxsize=1)
def get_conn_dict(rds_id, db_name):

    result = {}
    rds_client = boto3.client('rds')
    try:
        response = rds_client.describe_db_instances(
            DBInstanceIdentifier=rds_id)

        instance = response.get('DBInstances')[0]
        endpoint = instance.get('Endpoint')
        endpoint_address = endpoint.get('Address')
        endpoint_port = endpoint.get('Port')

        # Endpoint needs to be the rds endpoint, domain-name does not work
        # endpoint_address = 'postgres.bigmountaintiger.com'

        username = 'api_user'
        aws_region = 'us-east-1'
        token = rds_client.generate_db_auth_token(
            DBHostname=endpoint_address, Port=endpoint_port, DBUsername=username, Region=aws_region)
        
        print(token)
        print('--------------------------------')

        result = {
            'ENDPOINT': endpoint_address,
            'PORT': endpoint_port,
            'DBNAME': db_name,
            'USER': username,
            'REGION': aws_region,
            'TOKEN': token
        }

    finally:
        rds_client.close()

    return result
