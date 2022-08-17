import datetime
import boto3

TABLE_NAME = 'dynamodb-transaction-example-table'


def transact_put():
    def format_items(id):
        return [
            {
                'Put': {
                    'Item': {
                        'id': {
                            'S': id
                        },
                        'entry_name': {
                            'S': f'Name-{id}-{datetime.datetime.now()}'
                        }
                    },
                    'TableName': TABLE_NAME,
                    'ConditionExpression': 'attribute_not_exists(id)'
                }
            }
        ]

    transact_items = format_items('1')
    client = boto3.client('dynamodb')

    response = None
    try:
        response = client.transact_write_items(TransactItems=transact_items)
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)


def transact_update():
    def format_items(id):
        return [
            {
                'Update': {
                    'Key': {
                        'id': {
                            'S': id
                        }
                    },
                    'UpdateExpression': 'set entry_name = :n',
                    'ExpressionAttributeValues': {
                        ':n': {
                            'S': f'Name-{id}-{datetime.datetime.now()}'
                        }
                    },
                    'TableName': TABLE_NAME,
                    'ConditionExpression': 'attribute_exists(id)'
                }
            }
        ]

    transact_items = format_items('1')
    client = boto3.client('dynamodb')

    response = None
    try:
        response = client.transact_write_items(TransactItems=transact_items)
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)

def transact_delete():
    def format_items(id):
        return [
            {
                'Delete': {
                    'Key': {
                        'id': {
                            'S': id
                        }
                    },
                    'TableName': TABLE_NAME,
                    'ConditionExpression': 'attribute_exists(id)'
                }
            }
        ]

    transact_items = format_items('1')
    client = boto3.client('dynamodb')

    response = None
    try:
        response = client.transact_write_items(TransactItems=transact_items)
    except Exception as e:
        print(type(e))
        print(str(e))
    finally:
        client.close()

    print(response)