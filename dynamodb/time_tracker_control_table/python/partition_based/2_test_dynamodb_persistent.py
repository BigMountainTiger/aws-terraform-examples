from datetime import datetime, timezone
from utils.dynamodb_utils import DynamoDBTimePartitionTracker, Partition

if __name__ == '__main__':

    dynamodb_table_name, table_to_track = "time_tracker_control_table", "example_partition_based_table"
    tracker = DynamoDBTimePartitionTracker(dynamodb_table_name, table_to_track)

    partition = tracker.get_last_partition()
    print(partition)

    if partition is None:
        dt = datetime.now(tz=timezone.utc)
        partition = Partition.from_datetime(dt)

    partition = partition.next_partition()
    tracker.update_last_partition(partition)

    partition = tracker.get_last_partition()
    print(partition)
