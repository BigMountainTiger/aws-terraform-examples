import json


def lambdaHandler(event, context):

    print(event)
    print(context)

    return {
        'statusCode': 200,
        'headers': {
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(event)
    }
