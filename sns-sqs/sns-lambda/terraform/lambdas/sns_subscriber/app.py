import json


def lambdaHandler(event, context):

    Records = event['Records']
    for record in Records:
        message = record['Sns']['Message']

        print(message)

    return {
        'statusCode': 200,
        'body': 'Success'
    }
