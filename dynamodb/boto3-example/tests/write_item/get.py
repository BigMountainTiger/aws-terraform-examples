import unittest
from src import write_item_example as example


class DynamodbWriteTest(unittest.TestCase):
    def test_get(self):
        example.read()


if __name__ == '__main__':
    unittest.main()
