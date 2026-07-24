from datetime import datetime, timezone
from utils import pyspark_utils
from pyspark.sql import DataFrame
from pyspark.sql import functions as F

if __name__ == "__main__":
    spark = pyspark_utils.get_spark_session()

    def create_schema():
        return pyspark_utils.generate_schema_from_json_data({
            "key_1": "",
            "key_2": {
                "str_entry_1": "",
                "int_entry": 0,
                "double_entry": 0.0,
                "pass": True
            }
        })

    schema = create_schema()

    def create_data_frame(data) -> DataFrame:
        return spark.createDataFrame(data, schema=schema)

    def write_to_parquet(df: DataFrame):
        bucket = "iceberg-example-huge-head-li"
        s3_parquet_path = f"s3://{bucket}/files"

        now = datetime.now(tz=timezone.utc)
        y, m, d, h = now.strftime('%Y'), now.strftime('%m'), now.strftime('%d'), now.strftime('%H')
        time_prefix = f'year={y}/month={m}/day={d}/hour={h}'

        # To avoid tiny parquet files
        df.coalesce(1).write.save(path=f"{s3_parquet_path}/{time_prefix}", format="parquet", mode="append")

    df = create_data_frame([
        {"key_1": "OK", "key_2": {"str_entry_1": "OK", "int_entry": 0, "double_entry": 0.0}},
        {"key_1": 1, "key_2": {"str_entry_1": 1, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": 1.1, "key_2": {"str_entry_1": 1.1, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": True, "key_2": {"str_entry_1": False, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": {}, "key_2": {"str_entry_1": {}, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": {"key": "value"}, "key_2": {"str_entry_1": {"key": "value"}, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": [], "key_2": {"str_entry_1": [{"k_1", "v_1"}, {"k_2": "v_2"}], "int_entry": 0, "double_entry": 0.0}}
    ])

    df.show()
    write_to_parquet(df)
    print('Wrote the first batch\n')

    df = create_data_frame([
        {"key_2": {"int_entry": 0, "double_entry": 0.0}},
        {"key_2": {"int_entry": 1, "double_entry": 2.0}}
    ])

    df.show()
    write_to_parquet(df)
    print('Wrote the 2nd batch')
