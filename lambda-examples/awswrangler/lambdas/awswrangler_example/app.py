import awswrangler as wr
import pandas as pd
import json


def lambdaHandler(event, context):

    body = 'Initial Value'

    # The lambda code is deployed outside of terraform

    return {
        'statusCode': 200,
        'body': body
    }
