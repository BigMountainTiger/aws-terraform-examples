import unittest
from tests.integration.context import LambdaContext
from src.lambda_function import lambda_handler


class IntegrationTest(unittest.TestCase):
    def test_invoke_lambda(self):
        aws_context = LambdaContext('lambda_function')
        event = {}

        print()
        response = lambda_handler(event, aws_context)
        print(response)
