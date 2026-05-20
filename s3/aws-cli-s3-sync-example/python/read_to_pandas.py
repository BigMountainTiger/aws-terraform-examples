import pandas as pd

bucket = 's3-sync-example-huge-head-li'
target_object_key = 'database/example/mnt=202512/example-202512.csv'

if __name__ == '__main__':
    csv_path = f's3://{bucket}/{target_object_key}'
    df = pd.read_csv(csv_path)

    df.info()

    df = df.convert_dtypes()

    df.info()

    print(df)
