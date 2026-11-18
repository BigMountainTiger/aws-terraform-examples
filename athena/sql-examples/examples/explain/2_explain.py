import boto3
from athena_client import AthenaClient
import pandas as pd

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
table = "frac_example"

athena_client = AthenaClient(f"s3://{s3_bucket}/athena/")

sql = f"EXPLAIN SELECT * FROM {database}.{table}"

result = athena_client.execute_sql_query(sql=sql)
s3_path = result["ResultConfiguration"]["OutputLocation"]
bucket, key = s3_path.replace("s3://", "").split("/", 1)

s3 = boto3.client("s3")
plan_text = s3.get_object(Bucket=bucket, Key=key)["Body"].read().decode("utf-8")
print(plan_text)
