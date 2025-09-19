import boto3
import json


def publish(msg):
    arn = 'arn:aws:sns:us-east-1:939653976686:sns-lambda-example'
    client = boto3.client('sns')

    response = client.publish(TopicArn=arn, Message=json.dumps(msg))
    print(f'Message published successfully. Message ID: {response["MessageId"]}')


def lambdaHandler(event, context):

    msg = {
        'key1': 'value1',
        'key2': 'value2'
    }

    publish(msg)

    return {
        'statusCode': 200,
        'body': 'Success'
    }
