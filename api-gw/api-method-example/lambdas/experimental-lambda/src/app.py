import json

# Exceptionn in the handler does not kill the lambda
# The same lambda instance will keep running

ct = 0


def lambdaHandler(event, context):
    global ct
    ct += 1

    if ct == 3:
        raise Exception(f'Artifical exception @ ct={ct}')

    return {
        'statusCode': 200,
        'body': json.dumps(f'Experimental, accessed {ct} times')
    }
