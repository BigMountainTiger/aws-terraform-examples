import json


def lambdaHandler(event, context):

    body = 'Initial Value'

    return {
        'statusCode': 200,
        'body': body
    }
