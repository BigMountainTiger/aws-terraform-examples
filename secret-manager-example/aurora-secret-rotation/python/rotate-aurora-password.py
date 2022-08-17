import boto3
import os


CLUSTER = os.environ['CLUSTER']
print(CLUSTER)

client = boto3.client('rds')
response = client.modify_db_cluster(
    ApplyImmediately=True,
    DBClusterIdentifier=CLUSTER,
    RotateMasterUserPassword=True
)

print(response)