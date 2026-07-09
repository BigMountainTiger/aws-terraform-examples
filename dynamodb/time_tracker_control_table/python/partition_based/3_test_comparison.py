from datetime import datetime, timezone
from utils.dynamodb_utils import Partition

if __name__ == '__main__':

    dt = datetime.now(tz=timezone.utc)
    partition = Partition(dt=dt)
    partition_1 = Partition(dt=dt)
    partition_2 = Partition(dt=dt)

    previoud_partition = partition.previous_partition()
    next_partition = partition.next_partition()

    print("Expecting True:")
    print(partition_1 == partition_2)
    print(partition_1 >= partition_2)
    print(partition_1 <= partition_2)
    print(partition > previoud_partition)
    print(partition >= previoud_partition)
    print(partition < next_partition)
    print(partition <= next_partition)

    print("\nExpecting False:")
    print(partition_1 != partition_2)
    print(partition_1 > partition_2)
    print(partition_1 < partition_2)
    print(partition == previoud_partition)
    print(partition <= previoud_partition)
    print(partition < previoud_partition)
    print(partition == next_partition)
    print(partition >= next_partition)
    print(partition > next_partition)
