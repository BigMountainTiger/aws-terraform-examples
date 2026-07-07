import boto3


dynamodb = boto3.resource('dynamodb')


def create_initial_partition_entry(dynamodb_table, entry):
    table = dynamodb.Table(dynamodb_table)

    response = table.get_item(Key={'table_name': entry})
    if 'Item' not in response:
        table.put_item(Item={
            'table_name': entry,
            'last_timestamp': '1970-01-01T00:00:00Z'
        })
        print(f"Initial timestamp entry created for table '{entry}' in DynamoDB.")
    else:
        print(f"Entry for table '{entry}' already exists in DynamoDB.")


def get_last_processed_timestamp(table_name, glue_table):
    """Get the last processed timestamp for a specific Glue table."""
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    response = table.get_item(Key={'table_name': glue_table})
    if 'Item' in response and 'last_timestamp' in response['Item']:
        return response['Item']['last_timestamp']
    # Default: process from the beginning
    return '1970-01-01T00:00:00Z'


def update_last_processed_timestamp(table_name, glue_table, max_timestamp):
    """Update the last processed timestamp for a specific Glue table."""
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    table.update_item(
        Key={'table_name': glue_table},
        UpdateExpression="SET last_timestamp = :ts",
        ExpressionAttributeValues={':ts': max_timestamp}
    )


def create_initial_partition_entry_with_partition_info(dynamodb_table, glue_table):
    """
    Create an initial partition entry in DynamoDB with partition columns if it does not exist.
    This method initializes both timestamp and partition info for jobs that use partition optimization.
    """
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(dynamodb_table)

    # Check if entry exists
    response = table.get_item(Key={'table_name': glue_table})
    if 'Item' not in response:
        # Create initial entry with default values including partition info
        item = {
            'table_name': glue_table,
            'last_timestamp': '1970-01-01T00:00:00Z',
            'partition_year': 1970,
            'partition_month': 1,
            'partition_day': 1,
            'partition_hour': 0
        }
        table.put_item(Item=item)
        print(f"Initial timestamp and partition entry created for table '{glue_table}' in DynamoDB.")
    else:
        # Check if existing entry has partition columns, if not add them
        item = response['Item']
        needs_update = False
        update_expr_parts = []
        expr_values = {}

        # Check and add missing partition columns with default values
        if 'partition_year' not in item:
            update_expr_parts.append("partition_year = :year")
            expr_values[':year'] = 1970
            needs_update = True

        if 'partition_month' not in item:
            update_expr_parts.append("partition_month = :month")
            expr_values[':month'] = 1
            needs_update = True

        if 'partition_day' not in item:
            update_expr_parts.append("partition_day = :day")
            expr_values[':day'] = 1
            needs_update = True

        if 'partition_hour' not in item:
            update_expr_parts.append("partition_hour = :hour")
            expr_values[':hour'] = 0
            needs_update = True

        if needs_update:
            update_expr = "SET " + ", ".join(update_expr_parts)
            table.update_item(
                Key={'table_name': glue_table},
                UpdateExpression=update_expr,
                ExpressionAttributeValues=expr_values
            )
            print(f"Added missing partition columns to existing entry for table '{glue_table}' in DynamoDB.")
        else:
            print(f"Entry for table '{glue_table}' already exists with partition info in DynamoDB.")


def update_last_processed_with_partition_info(table_name, glue_table, max_timestamp, partition_info):
    """
    Update the last processed timestamp and partition information for a specific Glue table.
    Uses partition info directly from the query result.

    Args:
        table_name: DynamoDB table name
        glue_table: Glue table name (used as key in DynamoDB)
        max_timestamp: Maximum timestamp from the query results
        partition_info: Dictionary containing year, month, day, hour from query
    """
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)

    # Update both timestamp and partition info
    update_expr = "SET last_timestamp = :ts, partition_year = :year, partition_month = :month, " \
                  "partition_day = :day, partition_hour = :hour"

    table.update_item(
        Key={'table_name': glue_table},
        UpdateExpression=update_expr,
        ExpressionAttributeValues={
            ':ts': max_timestamp,
            ':year': partition_info['year'],
            ':month': partition_info['month'],
            ':day': partition_info['day'],
            ':hour': partition_info['hour']
        }
    )

    return partition_info


def get_last_processed_partition_info(table_name, glue_table):
    """
    Get the last processed partition information for a specific Glue table.
    Returns both timestamp and partition details.
    """
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(table_name)
    response = table.get_item(Key={'table_name': glue_table})

    if 'Item' not in response:
        # Default values for first run
        return {
            'last_timestamp': '1970-01-01T00:00:00Z',
            'partition_info': None
        }

    item = response['Item']
    partition_info = None

    # Check if partition info exists
    if all(k in item for k in ['partition_year', 'partition_month', 'partition_day', 'partition_hour']):
        partition_info = {
            'year': item['partition_year'],
            'month': item['partition_month'],
            'day': item['partition_day'],
            'hour': item['partition_hour']
        }

    return {
        'last_timestamp': item.get('last_timestamp', '1970-01-01T00:00:00Z'),
        'partition_info': partition_info
    }
