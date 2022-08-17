# https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html
# https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_RotateSecret.html
# https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas/blob/master/SecretsManagerRDSPostgreSQLRotationMultiUser/lambda_function.py

# "rds-data:BatchExecuteStatement",
# "rds-data:BeginTransaction",
# "rds-data:CommitTransaction",
# "rds-data:ExecuteSql",
# "rds-data:ExecuteStatement",
# "rds-data:RollbackTransaction"

import asyncio
import aioboto3
import psycopg2
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SESSION: aioboto3.Session = aioboto3.Session(region_name='us-east-1')

user = 'postgres'
host = 'experiment-postgres.cfa5drybscc2.us-east-1.rds.amazonaws.com'
port = 5432
database = 'postgres'


def lambda_handler(event, context):
    return asyncio.run(main(event))


async def main(event):
    ARN = event['SecretId']
    TOKEN = event['ClientRequestToken']
    STEP = event['Step']

    logger.info(f'Step {STEP}')
    async with SESSION.client('secretsmanager') as sm_client:
        if STEP == 'createSecret':
            await create_secret(sm_client, ARN, TOKEN)

        elif STEP == 'setSecret':
            await set_secret(sm_client, ARN, TOKEN)

        elif STEP == 'testSecret':
            await test_secret(sm_client, ARN, TOKEN)

        elif STEP == 'finishSecret':
            await finish_secret(sm_client, ARN, TOKEN)
        else:
            logger.error(
                'lambda_handler: Invalid step parameter %s for secret %s' % (STEP, ARN))
            raise ValueError(
                'Invalid step parameter %s for secret %s' % (STEP, ARN))


async def create_secret(sm_client, arn, token):
    await load_secret(sm_client, arn, 'AWSCURRENT')

    try:
        await load_secret(sm_client, arn, 'AWSPENDING', token)
        logger.info('createSecret: Successfully retrieved secret for %s.' % arn)
    except (
        sm_client.exceptions.ResourceNotFoundException,
        sm_client.exceptions.InvalidRequestException
    ):

        excluded_characters = ':/@"\'\\'
        response = await sm_client.get_random_password(ExcludeCharacters=excluded_characters, PasswordLength=20)
        password = response['RandomPassword']

        await sm_client.put_secret_value(
            ClientRequestToken=token,
            SecretId=arn,
            SecretString=password,
            VersionStages=['AWSPENDING']
        )

        logger.info('Successfully put the secret')


async def set_secret(sm_client, arn, token):
    current_password = await load_secret(sm_client, arn, 'AWSCURRENT')
    new_password = await load_secret(sm_client, arn, 'AWSPENDING', token)

    update_password(current_password, new_password)
    logger.info('Successfully updated the master password')


async def test_secret(sm_client, arn, token):
    new_password = await load_secret(sm_client, arn, 'AWSPENDING', token)
    valid = password_is_valid(new_password)

    if not valid:
        raise ValueError(
            f'Unable to log into the database with the pending secret ARN {arn}')

    logger.info('Successfully tested the pending secret')


async def finish_secret(sm_client, arn, token):

    metadata = await sm_client.describe_secret(SecretId=arn)
    current_version = None
    for version in metadata["VersionIdsToStages"]:
        if "AWSCURRENT" in metadata["VersionIdsToStages"][version]:
            if version == token:
                logger.info(
                    "finishSecret: Version %s already marked as AWSCURRENT for %s" % (version, arn))
                return

            current_version = version
            break

    await sm_client.update_secret_version_stage(
        SecretId=arn,
        VersionStage="AWSCURRENT",
        MoveToVersionId=token,
        RemoveFromVersionId=current_version
    )
    logger.info(
        "finishSecret: Successfully set AWSCURRENT stage to version %s for secret %s." % (token, arn))


async def load_secret(sm_client, arn, stage, token=None):
    if token:
        secret = await sm_client.get_secret_value(SecretId=arn, VersionStage=stage, VersionId=token)
    else:
        secret = await sm_client.get_secret_value(SecretId=arn, VersionStage=stage)

    return secret['SecretString']


def update_password(current_password, new_password):
    try:
        conn = get_connection(current_password)
        cur = conn.cursor()
        cur.execute(
            f"ALTER USER {user} WITH ENCRYPTED PASSWORD '{new_password}'")
        conn.commit()

    finally:
        if conn:
            conn.close()


def password_is_valid(password):
    if not password:
        return False

    try:
        conn = get_connection(password)
    finally:
        if conn:
            conn.close()

    return True if conn else False


def get_connection(password):
    constr = f'postgres://{user}:{password}@{host}:{port}/{database}'

    try:
        conn = psycopg2.connect(constr)
    except Exception as e:
        conn = None

    return conn
