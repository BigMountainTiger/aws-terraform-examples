from utils.dynamodb_utils import DynamoDBTimeTracker


if __name__ == "__main__":
    dynamodb_table_name = "time_tracker_control_table"
    table_to_track = "example_glue_table"

    tracker = DynamoDBTimeTracker(dynamodb_table_name, table_to_track)

    def update_last_timestamp(new_timestamp):
        tracker.update_last_timestamp(new_timestamp)

    def read_last_timestamp():
        last_timestamp = tracker.get_last_timestamp()
        print(f"last_timestamp {last_timestamp}")

    read_last_timestamp()

    update_last_timestamp("2024-06-01T12:00:00Z")
    read_last_timestamp()

    update_last_timestamp("2026-07-04T00:00:00Z")
    read_last_timestamp()



