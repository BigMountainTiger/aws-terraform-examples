import unittest
import sys
import logging
import uuid
from src.secrete_rotation_lambda import lambda_handler

# createSecret
# setSecret
# testSecret
# finishSecret

logger = logging.getLogger()
stream_handler = logging.StreamHandler(sys.stdout)
logger.addHandler(stream_handler)


class TestLambdafunction(unittest.TestCase):

    def __init__(self, name: None):
        super().__init__(name)

        self.event = {
            'SecretId': 'postgres-password',
            'ClientRequestToken': str(uuid.uuid4()),
            'Step': None
        }

    def test_rotate_secret(self):

        print()
        event = self.event
        event['Step'] = 'createSecret'
        lambda_handler(event, None)
        print(f'\nDone {event["Step"]}')

        print()
        event = self.event
        event['Step'] = 'setSecret'
        lambda_handler(event, None)
        print(f'\nDone {event["Step"]}')

        print()
        event = self.event
        event['Step'] = 'testSecret'
        lambda_handler(event, None)
        print(f'\nDone {event["Step"]}')

        print()
        event = self.event
        event['Step'] = 'finishSecret'
        lambda_handler(event, None)
        print(f'\nDone {event["Step"]}')
