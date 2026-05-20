import json
from src import write_item_example
from src import write_transact_items_example

# There is serializable isolation between the following types of operation:
# Between any transactional operation and any standard write operation (PutItem, UpdateItem, or DeleteItem).
# Between any transactional operation and any standard read operation (GetItem).
# Between a TransactWriteItems operation and a TransactGetItems operation.


def lambda_handler(event, context):

    test_item = True
    test_transact_item = False

    if test_item:
        write_item_example.put()
        write_item_example.update()
        write_item_example.read()
        write_item_example.delete()

    if test_transact_item:
        write_transact_items_example.transact_put()
        write_transact_items_example.transact_update()
        write_transact_items_example.transact_delete()

    return {
        'statusCode': 200,
        'body': json.dumps('Test completed')
    }
