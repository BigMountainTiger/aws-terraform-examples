import unittest
from app import lambdaHandler

class TestLambdafunction(unittest.TestCase):

    result = lambdaHandler(None, None)
    print()
    print(result)