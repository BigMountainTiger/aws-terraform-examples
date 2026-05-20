import unittest
from src import write_item_example as example


class DynamodbWriteTest(unittest.TestCase):
    def test_delete(self):
        example.delete()


if __name__ == '__main__':
    unittest.main()
