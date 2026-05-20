import boto3
import json

sqs_url = 'https://sqs.us-east-1.amazonaws.com/939653976686/example-sqs-queue'


def publish(msg):
    client = boto3.client('sqs')
    
    response = client.send_message(QueueUrl=sqs_url, MessageBody=json.dumps(msg))
    print(f'Message sent successfully. Message ID: {response["MessageId"]}')


if __name__ == '__main__':

    msg = {
        'key1': 'value1',
        'key2': 'value2'
    }

    publish(msg)
