import unittest
from src import write_item_example as example


class DynamodbWriteTest(unittest.TestCase):
    def test_put(self):
        example.put()


if __name__ == '__main__':
    unittest.main()
