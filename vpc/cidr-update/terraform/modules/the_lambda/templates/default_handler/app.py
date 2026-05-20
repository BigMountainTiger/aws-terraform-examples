def lambda_handler(event, context):

    body = 'Success'

    return {
        'statusCode': 200,
        'body': body
    }
