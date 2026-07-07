from utils.dynamodb_utils import DynamoDBTimeTracker


if __name__ == "__main__":

    def convert_back_and_forth(timestring):
        partitions = DynamoDBTimeTracker.timestring_to_partitions(timestring)
        print(f"Original timestring: {timestring} -> Partitions: {partitions}")
        timestring = DynamoDBTimeTracker.partitions_to_timestring(partitions)
        print(f"Converted timestring: {timestring}")
        print("--------------------------------------------------\n")

    # No timezone
    convert_back_and_forth("2024-06-01T11:00:00")

    # Z
    convert_back_and_forth("2024-06-01T12:00:00Z")

    # Offset with or without ":"
    convert_back_and_forth("2026-07-04T00:00:00+0300")
    convert_back_and_forth("2026-07-04T00:00:00-04:00")

