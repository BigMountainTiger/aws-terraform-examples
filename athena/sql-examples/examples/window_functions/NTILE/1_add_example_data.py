import awswrangler as wr
import pandas as pd

s3_bucket = "sql-windows-function-huge-head-li"
database = "sql_windows_function_database"
table = "ntile_example"


def get_example_dataframe():
    data = {
        "school": [],
        "department": [],
        "student": []
    }

    for i in range(1, 20 + 1):
        data["school"].append("Georgia Tech")
        data["department"].append("Math")
        data["student"].append(f"student {i}")

    for i in range(1, 4 + 1):
        data["school"].append("Georgia Tech")
        data["department"].append("Engineering")
        data["student"].append(f"student {i}")

    for i in range(1, 7 + 1):
        data["school"].append("Harvard")
        data["department"].append("English")
        data["student"].append(f"student {i}")

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
