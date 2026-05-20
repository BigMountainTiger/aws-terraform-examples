import boto3

client = boto3.client('redshift-data')
# IAM - https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-identity-based.html


SQLS = [
    "drop table if exists Student;",
    "CREATE table if not exists Student (ID int, Name varchar (255));",
    """
        copy student from 's3://redshift-serverless-example-huge-head-li/data/'
        iam_role default
        delimiter '|'
        ignoreheader 1
    """
]


def run():
    print("Issuing commands:")
    for sql in SQLS:
        print(sql)

    response = client.batch_execute_statement(
        WorkgroupName='default-workgroup',
        Database='public',
        WithEvent=False,
        Sqls=SQLS
    )

    print()
    print(response)


if __name__ == '__main__':
    run()
