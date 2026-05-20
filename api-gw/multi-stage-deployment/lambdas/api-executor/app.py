import json


def lambdaHandler(event, context):

    print(event)
    print(context)

    stage_name = event['requestContext']['stage']

    return {
        'statusCode': 200,
        'body': f'Success from {stage_name}\n'
    }
