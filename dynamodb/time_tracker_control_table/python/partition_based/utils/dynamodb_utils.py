import boto3
from dataclasses import dataclass
from functools import total_ordering
import json
from datetime import datetime, timedelta


@total_ordering
@dataclass(frozen=True, init=False)
class Partition:
    y: str
    m: str
    d: str
    h: str

    def __init__(self, dt: datetime):
        object.__setattr__(self, "y", f'{dt.year:04d}')
        object.__setattr__(self, "m", f'{dt.month:02d}')
        object.__setattr__(self, "d", f'{dt.day:02d}')
        object.__setattr__(self, "h", f'{dt.hour:02d}')

    def to_datetime(self):
        return datetime(int(self.y), int(self.m), int(self.d), int(self.h))

    def to_dict(self):
        return {'y': self.y, 'm': self.m, 'd': self.d, 'h': self.h}

    def to_json(self):
        return json.dumps(self.to_dict())

    def previous_partition(self):
        dt = self.to_datetime()
        dt = dt - timedelta(hours=1)
        return self.__class__.from_datetime(dt)

    def next_partition(self):
        dt = self.to_datetime()
        dt = dt + timedelta(hours=1)
        return self.__class__.from_datetime(dt)

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented

        return self.to_datetime() == other.to_datetime()

    def __lt__(self, other):
        if not isinstance(other, self.__class__):
            return NotImplemented

        return self.to_datetime() < other.to_datetime()

    @classmethod
    def from_datetime(cls, dt):
        return cls(dt)

    @classmethod
    def from_y_m_d_h(cls, y, m, d, h):
        dt = datetime(int(y), int(m), int(d), int(h))
        return cls.from_datetime(dt)

    @classmethod
    def from_dict(cls, dict_ymdh):
        y, m, d, h = dict_ymdh['y'], dict_ymdh['m'], dict_ymdh['d'], dict_ymdh['h']
        return cls.from_y_m_d_h(y, m, d, h)

    @classmethod
    def from_json(cls, json_ymdh):
        return cls.from_dict(json.loads(json_ymdh))


class DynamoDBTimePartitionTracker:
    def __init__(self, dynamodb_table_name, table_to_track):
        dynamodb = boto3.resource('dynamodb')
        self.dynamodb_table = dynamodb.Table(dynamodb_table_name)
        self.table_to_track = table_to_track

    def get_last_partition(self) -> Partition:
        response = self.dynamodb_table.get_item(Key={'table_name': self.table_to_track})
        if 'Item' in response and 'last_partition' in response['Item']:
            return Partition.from_json(response['Item']['last_partition'])

        return None

    def update_last_partition(self, partition: Partition):
        self.dynamodb_table.put_item(Item={
            'table_name': self.table_to_track,
            'last_partition': partition.to_json()
        })
