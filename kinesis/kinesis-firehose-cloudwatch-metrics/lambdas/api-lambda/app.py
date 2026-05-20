# https://docs.aws.amazon.com/firehose/latest/dev/httpdeliveryrequestresponse.html#requestformat
# Need to get the "X-Amz-Firehose-Request-Id" from the "headers"

import json
import time


def lambdaHandler(event, context):

    print(event)

    headers = event["headers"]
    request_id = headers["X-Amz-Firehose-Request-Id"]

    # request_id is also in the body, and the data is base64 encoded
    reuest_body = event["body"]
    print(reuest_body)

    response_body = {
        "requestId": request_id,
        "timestamp": int(time.time())
    }

    print(response_body)

    return {
        'statusCode': 200,
        'body': json.dumps(response_body)
    }
