# Need to manually update the function code here
# https://docs.aws.amazon.com/lambda/latest/dg/services-sqs-errorhandling.html
def lambdaHandler(event, context):
    records = event["Records"]

    print(f'This is a template lambda that sends the events back to the queue without any processing')
    print(f'Total {len(records)} events received')

    # This exception is on-purpose
    # The SQS recognizes the message is not processed and will try to re-deliver
    raise Exception("Raise an artificial exception, so the messages remain in the queue")
