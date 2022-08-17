import http.client
import json
import os

def generate_policy(effect, resource, JWKS_DOMAIN):
  return {
    'policyDocument': {
      'Version': '2012-10-17',
      'Statement': [{
        'Action': 'execute-api:Invoke',
        'Effect': effect,
        'Resource': resource
      }]
    },
    'context': {
      'JWKS_DOMAIN': JWKS_DOMAIN
    }
  }

def lambdaHandler(event, context):
  print(event)

  JWKS_DOMAIN = os.getenv('JWKS_DOMAIN')
  JWKS_PATH = os.getenv('JWKS_PATH')

  conn = http.client.HTTPSConnection(JWKS_DOMAIN)
  conn.request('GET', JWKS_PATH)
  response = conn.getresponse()

  keys = json.loads(response.read().decode()).get('keys')

  print(keys)
  
  method_arn = event.get('methodArn')
  authorization = (event.get('headers') or {}).get('Authorization')
  policy = generate_policy('Deny', "*", None)

  if authorization == 'ALLOW':
    policy = generate_policy('Allow', method_arn, JWKS_DOMAIN)

  return policy

