import json


def lambdaHandler(event, context):
    print(event)
    body = 'Initial Value'

    return {
        'statusCode': 200,
        'body': body
    }
