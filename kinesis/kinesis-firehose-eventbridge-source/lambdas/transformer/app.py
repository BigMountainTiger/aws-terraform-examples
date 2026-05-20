import base64
import json

# https://docs.aws.amazon.com/firehose/latest/dev/data-transformation-status-model.html

# result – The status of the data transformation of the record:
#   - Ok (the record was transformed successfully)
#   - Dropped (the record was dropped intentionally by your processing logic)
#   - ProcessingFailed (the record could not be transformed)

# Ok or Dropped => successfully processed. Otherwise => unsuccessfully processed.


def lambdaHandler(event, context):

    records = event['records']
    output = []

    for record in event['records']:
        payload = base64.b64decode(record['data']).decode()
        payload = json.loads(payload)

        detail = payload['detail']

        output_record = {
            'result': 'Ok',
            'recordId': record['recordId'],
            'data': base64.b64encode(f'{json.dumps(detail)}\n'.encode('utf-8'))
        }
        output.append(output_record)

    print(f'Successfully processed {len(records)} records.')
    return {'records': output}
