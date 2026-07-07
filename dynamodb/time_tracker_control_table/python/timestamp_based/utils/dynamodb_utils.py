import boto3
from datetime import datetime


class DynamoDBTimeTracker:
    def __init__(self, dynamodb_table_name, table_to_track):
        dynamodb = boto3.resource('dynamodb')
        self.dynamodb_table = dynamodb.Table(dynamodb_table_name)
        self.table_to_track = table_to_track

        self.default_initial_last_timestamp = '1970-01-01T00:00:00'

    @staticmethod
    def timestring_to_partitions(timestring):
        dt = datetime.fromisoformat(timestring)

        def tz(tzinfo):
            return None if tzinfo is None else datetime.now(tzinfo).strftime('%z')

        return {'y': dt.year, 'm': dt.month, 'd': dt.day, 'h': dt.hour, 'tz': tz(dt.tzinfo)}

    @staticmethod
    def partitions_to_timestring(partitions):

        def get_tzinfo(tz):
            if tz is None:
                return None

            tz = tz.strip()
            tz = '+0000' if tz == 'Z' else tz
            tz = tz.replace(':', '') if ':' in tz else tz

            return datetime.strptime(tz, '%z').tzinfo

        dt = datetime(partitions['y'], partitions['m'], partitions['d'], partitions['h'], tzinfo=get_tzinfo(partitions.get('tz')))
        return dt.isoformat()

    def get_last_timestamp(self):
        response = self.dynamodb_table.get_item(Key={'table_name': self.table_to_track})
        if 'Item' in response and 'last_timestamp' in response['Item']:
            return response['Item']['last_timestamp']

        return self.default_initial_last_timestamp

    def update_last_timestamp(self, max_timestamp):
        self.dynamodb_table.put_item(Item={'table_name': self.table_to_track, 'last_timestamp': max_timestamp})
