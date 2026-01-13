import pandas as pd


class CSVClient:

    def read_csv(self, path: str) -> pd.DataFrame:
        df = pd.read_csv(path)
        return df.convert_dtypes()

    def write_csv(self, df: pd.DataFrame, path: str) -> None:
        df = df.convert_dtypes()
        df.to_csv(path, index=False)
