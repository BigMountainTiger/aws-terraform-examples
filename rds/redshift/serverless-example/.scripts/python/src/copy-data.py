import boto3

client = boto3.client('redshift-data')
# IAM - https://docs.aws.amazon.com/redshift/latest/mgmt/redshift-iam-access-control-identity-based.html

# To run the SQL command
# 1. The data file is uploaded to the s3
# 2. The table is created in redshift
SQL = """
    copy student from 's3://redshift-serverless-example-huge-head-li/data/'
    iam_role default
    delimiter '|'
    ignoreheader 1
"""


def run():
    print("Issuing command:")
    print(SQL)
    response = client.execute_statement(
        WorkgroupName='default-workgroup',
        Database='public',
        WithEvent=False,
        Sql=SQL
    )

    print()
    print(response)


if __name__ == '__main__':
    run()
