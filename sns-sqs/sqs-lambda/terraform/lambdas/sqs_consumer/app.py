import json


def lambdaHandler(event, context):

    Records = event['Records']
    for record in Records:
        body = record['body']

        print(body)

    return {
        'statusCode': 200,
        'body': 'Success'
    }
