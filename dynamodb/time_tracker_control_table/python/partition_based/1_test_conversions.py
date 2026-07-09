from datetime import datetime, timezone
from utils.dynamodb_utils import Partition

if __name__ == '__main__':

    dt = datetime.now(tz=timezone.utc)

    partition = Partition.from_datetime(dt)
    print(partition)

    partition = Partition.from_json(partition.to_json())
    print(partition)

    partition = partition.previous_partition()
    print(partition)

    partition = partition.next_partition()
    print(partition)

    partition = Partition.from_y_m_d_h('2026', '07', '07', '00')
    print(partition)

    partition = Partition.from_y_m_d_h(2026, 7, 7, 0)
    print(partition)
