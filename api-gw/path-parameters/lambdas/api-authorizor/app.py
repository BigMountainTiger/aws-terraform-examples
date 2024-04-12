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
    policy = generate_policy('Allow', method_arn)

    return policy
