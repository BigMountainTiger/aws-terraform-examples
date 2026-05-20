import os
import json
import boto3


def lambdaHandler(event, context):

    SSM_PARAMETER_NAME = os.environ['SSM_PARAMETER_NAME']

    client = boto3.client('ssm')
    response = client.get_parameter(Name=SSM_PARAMETER_NAME)
    params = json.loads(response['Parameter']['Value'])

    return params
