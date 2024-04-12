import json


def lambdaHandler(event, context):

    # print(event)

    params = {
        'pathParameters': event.get('pathParameters', {}),
        'queryStringParameters': event.get('queryStringParameters', {})
    }

    return {
        'statusCode': 200,
        'body': json.dumps(params)
    }
