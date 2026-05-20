# Need to manually update the function code here
# https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-errorhandling.html

# 1. This lambda logs the basic information of the SQS events to the cloudwatch
# 2. This lambda raises an aritificial exception to notify the SQS that the events are not processed so they remain in the queue

def lambda_handler(event, context):
    records = event["Records"]

    print(f'This is a template lambda that sends the events back to the queue without any processing')
    print(f'Total {len(records)} events received')

    # This exception is on-purpose
    # The SQS recognizes the message is not processed and will try to re-deliver
    raise Exception(
        "Raise an artificial exception, so the messages remain in the queue")
