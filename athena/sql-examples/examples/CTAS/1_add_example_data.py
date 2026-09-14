import awswrangler as wr
import pandas as pd

s3_bucket = "athena-sql-examples-huge-head-li"
database = "athena_sql_examples_database"
table = "ctas_example_source_data"


def get_example_dataframe():
    data = {
        "mnt": [],
        "id": [],
        "name": []
    }

    for i in range(1, 5 + 1):
        data["mnt"].append(202601)
        data["id"].append(i)
        data["name"].append(f"name {i}")

    for i in range(1, 6 + 1):
        data["mnt"].append(202602)
        data["id"].append(i)
        data["name"].append(f"name {i}")

    for i in range(1, 7 + 1):
        data["mnt"].append(202603)
        data["id"].append(i)
        data["name"].append(f"name {i}")

    return pd.DataFrame(data=data)


df = get_example_dataframe()
df = df.convert_dtypes(dtype_backend="pyarrow")
df.info()

wr.s3.to_parquet(
    df=df,
    path=f"s3://{s3_bucket}/{database}/{table}",
    dataset=True,
    database=database,
    table=table,
    mode="overwrite"
)

print("Done")
