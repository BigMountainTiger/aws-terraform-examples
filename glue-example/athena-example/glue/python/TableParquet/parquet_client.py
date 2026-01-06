import pandas as pd
import awswrangler as wr


class ParquetClient:

    def read_parquet(self, path: str) -> pd.DataFrame:
        df = wr.s3.read_parquet(path=path)
        return df.convert_dtypes()

    def write_parquet(self, df: pd.DataFrame, path: str) -> None:
        df = df.convert_dtypes()
        df.to_parquet(path=path, engine='pyarrow', index=False)