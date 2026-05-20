import boto3
import json


def publish(msg):
    client = boto3.client('sqs')

    sqs_url = 'https://sqs.us-east-1.amazonaws.com/939653976686/example-sqs-queue'
    response = client.send_message(QueueUrl=sqs_url, MessageBody=json.dumps(msg))
    print(f'Message sent successfully. Message ID: {response["MessageId"]}')


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
