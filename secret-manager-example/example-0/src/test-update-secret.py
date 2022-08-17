import asyncio
import aioboto3
import datetime
import json


SESSION: aioboto3.Session = aioboto3.Session(region_name='us-east-1')

# It looks like both secret name and arn work
# secret_id = 'arn:aws:secretsmanager:us-east-1:939653976686:secret:example/user/pass-XJp3R4'
secret_id = 'example/user/pass'


async def run():

    new_secret = {
        'password':f'New secret - {datetime.datetime.now().strftime("%H:%M:%S.%f %m/%d/%Y")}'
    }

    # Get a randome password
    async with SESSION.client('secretsmanager') as sm_client:
        response = await sm_client.get_random_password(PasswordLength=20)
        new_secret['password'] = response['RandomPassword']

    print('Get a randome password')

    # Update the password
    async with SESSION.client('secretsmanager') as sm_client:
        secret = await sm_client.put_secret_value(
            SecretId=secret_id,
            SecretString=json.dumps(new_secret)
        )

    print('Finished put new secret value')

    # Retrieve the password
    async with SESSION.client('secretsmanager') as sm_client:
        secret = await sm_client.get_secret_value(SecretId=secret_id)
        print(secret)
        print()

    return secret['SecretString']

if __name__ == '__main__':

    try:
        result = asyncio.run(run())
    except Exception as ex:
        print(ex)

    print(result)
