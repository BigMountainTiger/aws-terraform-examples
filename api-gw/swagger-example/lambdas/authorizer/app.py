def generate_policy(effect, resource):
    return {
        'policyDocument': {
            'Version': '2012-10-17',
            'Statement': [{
                'Action': 'execute-api:Invoke',
                'Effect': effect,
                'Resource': resource
            }]
        }
    }


def lambdaHandler(event, context):

    print(event)

    method_arn = event.get('methodArn')
    headers = event.get('headers') or {}
    authorization = headers.get(
        'authorization') or headers.get('Authorization')

    policy = generate_policy('Deny', "*")
    if authorization == 'ALLOW':
        policy = generate_policy('Allow', method_arn)

    print(policy)

    return policy
