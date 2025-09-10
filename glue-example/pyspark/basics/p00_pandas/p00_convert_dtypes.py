import pandas as pd

# Reference
# - https://www.youtube.com/watch?v=CeqvH6DdMso&ab_channel=PythonandPandaswithReuvenLerner

D = {
    'id': [None, 0, 1],
    'name': ['nobody', 'Song', 'Biden'],
    'score': [10, 100, 10]
}

# By default the "id" column will be float so None/NaN can be included in the data
df = pd.DataFrame(D)
print(df.dtypes)
print(df)


print("\n\n++++++++++++++++++++++++++++")
# 1. Calling convert_dtypes() converts the types to the best fits that can include pd.NA
# 2. It is harmless to call convert_dtypes() more than once
df = df.convert_dtypes()
df = df.convert_dtypes()

print(df.dtypes)
print(df)