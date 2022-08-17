import json

def lambdaHandler(event, context):

  print(event)
  print(context)

  authorization = (event.get('headers') or {}).get('Authorization')
  JWKS_DOMAIN = ((event.get('requestContext') or {}).get('authorizer') or {}).get('JWKS_DOMAIN')

  return {
    'statusCode': 200,
    'body': f'Function invoked - {authorization} - {JWKS_DOMAIN}'
  }
