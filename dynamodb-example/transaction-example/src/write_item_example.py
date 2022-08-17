import datetime
import boto3

TABLE_NAME = 'dynamodb-transaction-example-table'


def put():
    client = boto3.client('dynamodb')

    item = {'id': {'S': '1'}, 'entry_name': {'S': None or ''}}

    response = None
    try:
        response = client.put_item(
            TableName=TABLE_NAME,
            Item=item,
            ConditionExpression='attribute_not_exists(id)'
        )
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)


def update():
    client = boto3.client('dynamodb')

    id = '1'
    key = {'id': {'S': id}}
    updateExpression = 'set entry_name = :n'
    expressionAttributeValues = {
        ':n': {
            'S': f'Name-{id}-{datetime.datetime.now()}'
        }
    }

    response = None
    try:
        response = client.update_item(
            TableName=TABLE_NAME,
            Key=key,
            UpdateExpression=updateExpression,
            ExpressionAttributeValues=expressionAttributeValues,
            ConditionExpression='attribute_exists(id)'
        )
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)


def delete():
    client = boto3.client('dynamodb')

    id = '1'
    key = {'id': {'S': id}}

    response = None
    try:
        response = client.delete_item(
            TableName=TABLE_NAME,
            Key=key,
            ConditionExpression='attribute_exists(id)'
        )
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)
