import time


def lambdaHandler(event, context):
    params = event['queryStringParameters']
    sleep = params['sleep']

    time.sleep(int(sleep))

    return {
        'statusCode': 200,
        'body': f'Slept for {sleep} seconds'
    }
