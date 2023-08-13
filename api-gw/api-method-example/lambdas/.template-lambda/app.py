import json


def lambdaHandler(event, context):

    print(event)
    print(context)

    return {
        'statusCode': 200,
        'body': json.dumps(event)
    }
