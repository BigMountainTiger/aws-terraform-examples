# While both pd.NA and np.nan are used to represent missing values, they have distinct behaviors:

# 1. np.nan is always a float, and its presence can force integer columns to become float.
# 2. pd.NA can be used with various data types without changing the column type.
# 3. pd.NA == 1 yields <NA>, while np.nan == 1 yields False.

import pandas as pd
import numpy as np

print(pd.NA == 1)
print(np.nan == 1)

# pd.NaT is similar to np.nan
print(pd.NaT == 1)
