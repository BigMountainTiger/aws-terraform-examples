from utils import pyspark_utils
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

    def create_data_frame(data):
        return spark.createDataFrame(data, schema=schema)

    # 1. string can take any types of data
    df = create_data_frame([
        {"key_1": "OK", "key_2": {"str_entry_1": "OK", "int_entry": 0, "double_entry": 0.0}},
        {"key_1": 1, "key_2": {"str_entry_1": 1, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": 1.1, "key_2": {"str_entry_1": 1.1, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": True, "key_2": {"str_entry_1": False, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": {}, "key_2": {"str_entry_1": {}, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": {"key": "value"}, "key_2": {"str_entry_1": {"key": "value"}, "int_entry": 0, "double_entry": 0.0}},
        {"key_1": [], "key_2": {"str_entry_1": [{"k_1", "v_1"}, {"k_2": "v_2"}], "int_entry": 0, "double_entry": 0.0}}
    ])

    df.printSchema()
    df.show()

    # 2. Missing entries is OK
    df = create_data_frame([
        {"key_2": {"int_entry": 0, "double_entry": 0.0}}
    ])
    df.show()

    # 3. int/long can not take float type data
    try:
        df = create_data_frame([{"key_2": {"int_entry": 0.0, "double_entry": 0.0}}])
    except Exception as e:
        print(e)

    # 4. float/double can not take int type data
    try:
        df = create_data_frame([{"key_2": {"int_entry": 0, "double_entry": 0}}])
    except Exception as e:
        print(e)

    # 5. boolean type can only take boolean data
    try:
        df = create_data_frame([
            {"key_2": {"pass": True}},
            {"key_2": {"pass": 0}}
        ])
    except Exception as e:
        print(e)
