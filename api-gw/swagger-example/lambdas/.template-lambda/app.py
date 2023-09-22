import json


def lambdaHandler(event, context):

    print(event)
    print(context)

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Methods': '*',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*'
        },
        'body': json.dumps(event)
    }
