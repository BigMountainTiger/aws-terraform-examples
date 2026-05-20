import boto3
import json

arn = 'arn:aws:sns:us-east-1:939653976686:sns-lambda-example'


def publish(msg):
    client = boto3.client('sns')
    
    response = client.publish(TopicArn=arn, Message=json.dumps(msg))
    print(f'Message published successfully. Message ID: {response["MessageId"]}')


if __name__ == '__main__':

    msg = {
        'key1': 'value1',
        'key2': 'value2'
    }

    publish(msg)
