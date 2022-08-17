import boto3
import os

CLUSTER = os.environ['CLUSTER']
print(CLUSTER)


def get_secret_arns():

    TagFilters = [
        {
            'Key': 'aws:secretsmanager:owningService',
            'Values': ['rds']
        },
        {
            'Key': 'aws:rds:primaryDBClusterArn',
            'Values': [CLUSTER]
        }
    ]

    ResourceTypeFilters = ['secretsmanager:secret']

    client = boto3.client('resourcegroupstaggingapi')
    response = client.get_resources(
        TagFilters=TagFilters, ResourceTypeFilters=ResourceTypeFilters)

    arns = []
    resources = response['ResourceTagMappingList']

    for r in resources:
        arns.append(r['ResourceARN'])

    return arns


def update_rotation_period(arn):
    client = boto3.client('secretsmanager')

    response = client.rotate_secret(
        SecretId=arn,
        RotationRules={
            'AutomaticallyAfterDays': 90
        }
    )

    if (response['ARN'] == arn):
        print('Success')


if __name__ == '__main__':

    arns = get_secret_arns()
    arn = arns[0]

    update_rotation_period(arn)
