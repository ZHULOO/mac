import pandas as pd
import numpy as np

y = pd.Series([12, 14, 15,21], index=pd.period_range('2018',freq='Y',periods=4))
q = q.resample('Q', convention='end').asfreq()


d = dict({'price': [10, 11, 9, 13, 14, 18, 17, 19],'volume': [50, 60, 40, 100, 50, 100, 40, 50]})
df = pd.DataFrame(d)
df['week_starting'] = pd.date_range('01/01/2018',periods=8,freq='W')
df.resample('M', on='week_starting').mean()


def custom_resampler(array_like):
    return np.sum(array_like) + 5

series.resample('3T').apply(custom_resampler)